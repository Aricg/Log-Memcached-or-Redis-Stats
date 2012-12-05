#!/bin/bash
#Path was biting me when running this script via cron.
PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
export PATH
#Defaults (memcached)
File_name=
Options="cmd_get"
Per_Seconds=10
ipaddress=127.0.0.1
Port=11211
Choice="memcached"

usage()
{
cat << EOF

usage: $0 options

This script gathers either Memcached info or Redis stats twice (defined by the wait interval -t) Then logs the diffrences for the inidcated statistic

OPTIONS: ( -f must be called first ) 
        -h       Show this message
        -f       Full path to statitics file 
        -r       redis or memcached (default is memcached)
        -i       ipaddress -Default 127.0.0.1
        -p       port -Defalt 11211
        -t       Wait Interval between fist and second memcache check -Default 10 seconds
        -o       Which statistics to check, wrapped in quotes seperated by a space -Default cmd_get
                        Memcached:
                                cmd_get
                                cmd_set
                                get_hits
                                get_misses
                                total_items
                                curr_items
                                bytes_read
                                bytes_written
                                bytes
                        Redis:
                                total_connections_received 
                                total_commands_processed 
                                keyspace_hits
                                keyspace_misses

Example $0 -f /var/log/memcached.log -i 127.0.0.1 -t 10 -o "cmd_get cmd_set get_hits get_misses bytes_read bytes_written"
Example $0 -f /var/log/redis.log -r redis -i 127.0.0.1 -t 10 -o "keys total_connections_received total_commands_processed keyspace_hits"

EOF
}
while getopts ":h:r:f:i:p:t:o:" OPTION
do
     case "$OPTION" in
         h)
             usage
             exit 1
             ;;
         r)
             Choice="$OPTARG"
             Port=6379
             ;;
         f)
             File_name="$OPTARG"
             ;;
         i)
             ipaddress="$OPTARG"
             ;;
         p)
             Port="$OPTARG"
             ;;
         t)
             Per_Seconds="$OPTARG"
             ;;
         o)
             Options="$OPTARG"
             ;;
         ?)
             usage
             exit
             ;;
     esac
done

if [[ -z $File_name ]]
then
     usage
     exit 1
fi


WriteStatsToFile () {
#Netcat is not as portable as I hoped, need to change this check to use netstat
if $(nc -z "$ipaddress" "$Port");
        then
                echo "Connected, Please wait "$(expr "$Per_Seconds" + 4 )" Seconds"  ;
        else
                echo "Cannot Connect to "$Choice", Exiting"
                        exit 1;
fi

if [[ $Choice = "redis" ]];
        then
                Stats_before="$(echo "info" | redis-cli -h "$ipaddress" -p "$Port" -x)"
                sleep $Per_Seconds
                Stats_after="$(echo "info" | redis-cli -h "$ipaddress" -p "$Port" -x)"
else

                Stats_before="$(echo stats | nc -q2 "$ipaddress" "$Port")"
                sleep $Per_Seconds
                Stats_after="$(echo stats | nc -q2 "$ipaddress" "$Port")"
fi


for x in $Options;
        do
                after=$(echo "$Stats_before" | grep "$x" | tr -dc '[0-9]')
                before=$(echo "$Stats_after" | grep "$x" | tr -dc '[0-9]')

                       echo "$(date | tr -d '\n')" "$x per $Per_Seconds Seconds:"  "$(expr "$before" - "$after" )" >> $File_name
        done
}

DisplayResults () {
tail "$File_name"
}

WriteStatsToFile
DisplayResults


