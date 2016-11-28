# nginx-cache-Status
Analyse nginx cache hit rates

This software is designed to analyse your nginx cache efficiency by analysing your access log.
Nothing else to say - enjoy !


**How to use**

Modify your custom log format to look like this:  
```
log_format rt_cache '$remote_addr - $upstream_cache_status [$time_local]' ' "$host" "$request" $status $body_bytes_sent ' '"$http_referer" "$http_user_agent"';
```
wait ...  
Run the script

```
/path/to/script/cachehitrate.sh /var/log/nginx/access.log
or
/path/to/script/cachehitrate.sh /var/www/yourvhost/log/access.log
```

**The Output**
```
HIT Ratio:       97.78092792055558013000                (7073707 hits)  
MISS ratio:      1.04677201751669836700                 (75726 misses)  
EXPIRY ratio:    1.17230006192772150200                 (84807 expires)  
```

as always: no shoes no shirt no service ;)
