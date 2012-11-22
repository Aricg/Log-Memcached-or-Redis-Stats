Log-Memcached-or-Redis-Stats
==============================

This script gathers either Memcached info or Redis stats twice (defined by the wait interval -t) Then logs the diffrences for the inidcated statistic


Usage
=====
	LogMemcachedorRedisStats.bash options

OPTIONS:
-------
	-h show this message
	-f full path to statitics file
	-r redis or memcached (default is memcached)
	-i ipaddress 								
	-p port 									
	-t wait Interval between fist and second memcache check 			
	-o which statistics to check, wrapped in quotes seperated by a space 	

Defaults:
--------
Memcached
	ipaddress 127.0.0.1
	port 11211
	wait Interval 10 seconds
	statistic cmd_get
Redis
	Port 6379
	statistic keys
	ipaddress 127.0.0.1
	wait Interval 10 seconds
        
Posible Statistics:
-----------------
Memcached	
	cmd_get
	cmd_set
	get_hits
	get_misses
	total_items
	bytes_read
	bytes_written
	bytes
Redis 
	total_connections_received 
	total_commands_processed 
	keyspace_hits
         
Example(s)
=========
	LogMemcachedorRedisStats.bash -f /var/log/memcached.log -i 127.0.0.1 -t 10 -o "cmd_get cmd_set get_hits get_misses bytes_read bytes_written"
	LogMemcachedorRedisStats.bash -f /var/log/redis.log -r redis -i 127.0.0.1 -t 10 -o "total_connections_received total_commands_processed keyspace_hits"

License
------
BSD

