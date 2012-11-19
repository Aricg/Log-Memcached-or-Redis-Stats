#!/bin/bash
File_name=
Options="cmd_get"
Per_Seconds=10
ipaddress=127.0.0.1
Port=11211

usage()
{
cat << EOF

usage: $0 options

This script gathers Memcached statistics twice (defined by the wait interval -t) Then logs the diffrences for the inidcated statistic

OPTIONS:
        -h      Show this message
        -i      ipaddress -Default 127.0.0.1
        -p      port -Defalt 11211
        -f      Full path to statitics file 
        -t      Wait Interval between fist and second memcache check -Default 10 seconds
        -o      Which statistics to check, wrapped in quotes seperated by a space -Default cmd_get
                        Resonable Values
                                cmd_get
                                cmd_set
                                get_hits
                                get_misses
                                total_items
                                curr_items
                                bytes_read
                                bytes_written
                                bytes
                        

Example $0 -f /tmp/memcached_stats -t2 -o "cmd_get cmd_set get_hits get_misses bytes_read bytes_written"

EOF
}
while getopts :h:i:p:t:f:o: OPTION
do
     case "$OPTION" in
         h)
             usage
             exit 1
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
         f)
             File_name="$OPTARG"
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

if $(nc -z "$ipaddress" "$Port");
        then
                echo "Connected, Please wait "$(expr "$Per_Seconds" + 4 )" Seconds"  ;
        else
                echo "Cannot Connect to Memcached, Exiting"
                        exit 1;
fi


Stats_before="$(echo stats | nc -q2 "$ipaddress" $Port)"
sleep $Per_Seconds
Stats_after="$(echo stats | nc -q2 "$ipaddress" $Port)"


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

