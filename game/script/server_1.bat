cd ../config
set LogFile=\"../logs/app_run1.log\"
erl +P 1024000 -smp disable -pa ../ebin -name titan_game1@127.0.0.1 -setcookie tian -boot start_sasl -config run_1 -kernel error_logger {file,"%LogFile%"} -s titan server_start
