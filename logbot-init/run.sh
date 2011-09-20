#!/bin/bash

cd /opt/LogBot/
/usr/bin/java -cp /opt/LogBot:/opt/LogBot/lib/pircbot.jar org.jibble.logbot.LogBotMain &> /dev/null &
echo $! > logbot.pid