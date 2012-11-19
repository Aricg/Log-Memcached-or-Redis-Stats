Log-Diffrences-Memcached-Stats
==============================

This script gathers Memcached statistics twice (defined by the wait interval -t) Then logs the diffrences for the inidicated statistic(s)

Usage
=====
	LogDifferencesMemcached.bash options

OPTIONS:
-------
	-h show this message
	-f full path to statitics file
	-i ipaddress 								
	-p port 									
	-t wait Interval between fist and second memcache check 			
	-o which statistics to check, wrapped in quotes seperated by a space 	

Defaults:
--------
	ipaddress 127.0.0.1
	port 11211
	wait Interval 10 seconds
	statistic cmd_get
                        
Posible Statistics:
-----------------
	cmd_get
	cmd_set
	get_hits
	get_misses
	total_items
	bytes_read
	bytes_written
	bytes
                        
Example(s)
=========

	LogDifferencesMemcached.bash -f /tmp/memcached_stats 
	LogDifferencesMemcached.bash -f /tmp/memcached_stats -i 0.0.0.0 -t10 -o "cmd_get cmd_set get_hits get_misses bytes_read bytes_written"


License
------
BSD

