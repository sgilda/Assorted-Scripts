These are modifications made to [LogBot] (http://www.jibble.org/logbot/) to 
enable running as a service in Red Hat Enterprise Linux 5.6

Assumptions: 

 * the program is located in `/opt/LogBot`
 * it will be run as the user `nobody`
 * the user nobody is able to read and write to the LogBot directory, 
specifically the file `logbot.pid`
 * the user nobody is able to read and write to the directory where the logs are written.
 * it will be running on run levels 3 and 5

1. Copy files to the `/opt/LogBot` directory
2. install init script: `ln -s /opt/LogBot/logbot /etc/init.d/logbot`
3. setup service to run: `chkconfig --level 35 logbot on`

Starting/Stopping/Restarting

 * To start LogBot: `service logbot start`
 * To stop LogBot: `service logbot stop`
 * To restart LogBot: `service logbot restart`

You will need to be root or sudo of course.

What these changes are:

 * `/opt/LogBot/run.sh` is a modified version of the original LogBot run.sh
 * the init script was borrowed from the [Bip] (http://bip.milkypond.org/) IRC proxy & modified.

