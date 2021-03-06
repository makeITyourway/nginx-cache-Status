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
t_miss=1
t_hit=1
t_expired=1


# preflight checks
if [ -z "$1" ] ; then
	echo "please specify the access logfile"
	exit 1
fi

# go parse
#for line in `cat $1 awk '{print $3}' $1 | sort | uniq -c | sort -r` ; do
for line in `cat $1 | awk '{print $3}' | sort | uniq -c | sort -r` ; do
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
all_reqs=$(echo "($t_hit + $t_expired + $t_miss)" | bc -l )
hit_ratio=$(echo "$t_hit / $all_reqs * 100" | bc -l)
miss_ratio=$(echo "$t_miss / $all_reqs * 100" | bc -l)
expired_ratio=$(echo "$t_expired / $all_reqs * 100" | bc -l)



# go output
echo -e "\nOVERALL STATS"
echo -e "HIT ratio:\t$hit_ratio \t\t($t_hit hits)"
echo -e "MISS ratio:\t$miss_ratio \t\t($t_miss misses)"
echo -e "EXPIRY ratio:\t$expired_ratio \t\t($t_expired expires)"



t_miss=1
t_hit=1
t_expired=1


for line in `tail -n 10000 $1 | awk '{print $3}' | sort | uniq -c | sort -r` ; do
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
echo -e "\nLAST 1000"
echo -e "HIT ratio:\t$hit_ratio \t\t($t_hit hits)"
echo -e "MISS ratio:\t$miss_ratio \t\t($t_miss misses)"
echo -e "EXPIRY ratio:\t$expired_ratio \t\t($t_expired expires)\n"



# go home
exit 0
