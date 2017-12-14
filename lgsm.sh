#!/bin/bash

## can be simplified.

## name of the docker process
InstanceName="arkserver"
## arkserver for me (it's the script name in the serveur directory)
ServerType="arkserver"
## Image name to run (i have build with the lgsm-build.sh)
Img="lgsm-docker"

if [ $1 != null ]
then
        echo $"Usage: $0 {start|stop|restart|console|monitor|update|backup|cronjob}"
	cmd=$@
else
	echo $"Usage: $0 {start|stop|restart|console|monitor|update|backup|cronjob}"
	read -a cmd
fi


case $cmd in
        "install")
            read -a type
	    sudo docker run --name $InstanceName --rm -it -d -v "/home/lgsm/:/home/lgsm" $Img bash 2> /dev/null
	    sudo docker exec $InstanceName $ServerType install $type
            ;;

        "start")
	    sudo docker run --name $InstanceName --rm -it -d -v "/home/lgsm/:/home/lgsm" $Img bash 2> /dev/null
            sudo docker exec $InstanceName $ServerType start
            ;;

        "stop")
	    sudo docker run --name $InstanceName --rm -it -d -v "/home/lgsm/:/home/lgsm" $Img bash 2> /dev/null
            sudo docker exec $InstanceName $ServerType stop
	    sudo docker kill $InstanceName
            ;;

        "restart")
	    sudo docker run --name $InstanceName --rm -it -d -v "/home/lgsm/:/home/lgsm" $Img bash 2> /dev/null
            sudo docker exec $InstanceName $ServerType restart
            ;;

        "console")
	    sudo docker run --name $InstanceName --rm -it -d -v "/home/lgsm/:/home/lgsm" $Img bash 2> /dev/null
            sudo docker exec $InstanceName $ServerType console
            ;;

        "monitor")
	    sudo docker run --name $InstanceName --rm -it -d -v "/home/lgsm/:/home/lgsm" $Img bash 2> /dev/null
            sudo docker exec $InstanceName $ServerType monitor
            ;;

        "update") ## update stop the server if is already running.
	    sudo docker run --name $InstanceName --rm -it -d -v "/home/lgsm/:/home/lgsm" $Img bash
            sudo docker exec $InstanceName $ServerType update
            ;;

        "backup")
	    sudo docker run --name $InstanceName --rm -it -d -v "/home/lgsm/:/home/lgsm" $Img bash
            sudo docker exec $InstanceName $ServerType backup
            ;;

        "conjob") ## need to be test.
            sudo docker run --name $InstanceName --rm -it -d -v "/home/lgsm/:/home/lgsm" $Img bash
            sudo docker exec $InstanceName crontab -l > tempcronfile
	    sudo docker exec $InstanceName echo "0 5 * * *  /home/lgsm/$ServerType update > /dev/null 2>&1" > tempcronfile
 	    sudo docker exec $InstanceName crontab tempcronfile && rm tempcronfile
            ;;

        *)
            echo $"Usage: $0 {start|stop|restart|console|monitor|update|backup}"
            exit 1

esac

#sudo docker run --name arkserver --rm -it -d -v "/home/lgsm/:/home/lgsm" lgsm-docker bash $@