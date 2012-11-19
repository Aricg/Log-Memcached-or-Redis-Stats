Log-Diffrences-Memcached-Stats
==============================

This script gathers Memcached statistics twice (defined by the wait interval -t) Then logs the diffrences for the inidcated statistic

Usage
=====
LogDifferencesMemcached.bash options

OPTIONS:
-------
	*h -Show this message
	*f -Full path to statitics file 
	*i -ipaddress 								
	*p -port 									
	*t -Wait Interval between fist and second memcache check 			
	*o -Which statistics to check, wrapped in quotes seperated by a space 	

Defaults:
--------
	*Ipaddress 127.0.0.1
	*Port 11211
	*Wait Interval 10 seconds
	*Statistic cmd_get
                        
Resonable Values:
-----------------
	*cmd_get
	*cmd_set
	*get_hits
	*get_misses
	*total_items
	*bytes_read
	*bytes_written
	*bytes
                        
Example(s)
=========

	LogDifferencesMemcached.bash -f /tmp/memcached_stats 
	LogDifferencesMemcached.bash -f /tmp/memcached_stats -i 0.0.0.0 -p -t10 -o "cmd_get cmd_set get_hits get_misses bytes_read bytes_written"


License
------
BSD

