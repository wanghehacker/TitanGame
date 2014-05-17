cd ../config
set LogFile=\"../logs/app_run1.log\"
erl +P 1024000 -smp disable -pa ../ebin -name titan_gateway@127.0.0.1 setcookie titan -boot start_sasl -config gateway -kernel error_logger {file,"%LogFile%"} -s titan gateway_start
