#!/bin/bash

##########
### by Mike Schiessl
### info@makeityourway.de
### www.miyw.de
### feel free to clone and modify - feedback is welcome
###
### requires nginx access log_format to look like this
### log_format rt_cache '$remote_addr - $upstream_cache_status [$time_local]' ' "$host" "$request" $status $body_bytes_sent ' '"$http_referer" "$http_user_agent"';
###
###########

# INIT
t_miss=0
t_hit=0
t_expired=0


# preflight checks
if [ -z "$1" ] ; then
	echo "please specify the access logfile"
	exit 1
fi

# go parse 
for line in `awk '{print $3}' $1 | sort | uniq -c | sort -r` ; do

	case $line in
		HIT)
			t_hit=$tmpvar
		;;
		MISS)
			t_miss=$tmpvar
		;;
		EXPIRED)
			t_expired=$tmpvar
		;;
		*)
			tmpvar=$line
		;;
	esac


done

# go calculate
all_reqs=$(echo "($t_hit + $t_expired + $t_miss)" | bc -l)

hit_ratio=$(echo "$t_hit / $all_reqs * 100" | bc -l)
miss_ratio=$(echo "$t_miss / $all_reqs * 100" | bc -l)
expired_ratio=$(echo "$t_expired / $all_reqs * 100" | bc -l)




# go output
echo -e "HIT Ratio: \t $hit_ratio \t\t($t_hit hits)"
echo -e "MISS ratio: \t $miss_ratio \t\t($t_miss misses)"
echo -e "EXPIRY ratio: \t $expired_ratio \t\t($t_expired expires)"


# go home
exit 0
