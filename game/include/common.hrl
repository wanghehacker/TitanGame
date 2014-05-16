%%%-------------------------------------------------------------------
%%% @author wanghe
%%% @copyright (C) 2014, <COMPANY>
%%% @doc  公共定义
%%%
%%% @end
%%% Created : 14. 五月 2014 10:10
%%%-------------------------------------------------------------------
-author("wanghe").
%%承载玩家数量
-define(ALL_SERVER_PLAYERS,100000).

%%数据库模块选择 (db_mysql 或 db_mongo)
-define(DB_MODULE,db_mongo).

%%mongo主数据库链接池
-define(MASTER_POOLID,master_mongo).

%%mongo主数据库链接池
-define(LOG_POOLID,log_mongo).

%%mongo从数据库链接池
-define(SLAVE_POOLID,slave_mongo).

%%Mysql数据库连接
-define(DB_POOL, mysql_conn).

%%ETS
-define(ETS_SERVER, ets_server).
-define(ETS_GET_SERVER,ets_get_server).
-define(ETS_SYSTEM_INFO,ets_system_info).           %% 系统配置信息
-define(ETS_MONITOR_PID,ets_monitor_pid).           %% 记录监控的PID
-define(ETS_STAT_SOCKET,ets_stat_socket).            %% Socket送出数据统计(协议号，次数)
-define(ETS_STAT_DB,ets_stat_db).                    %% 数据库访问统计(表名，操作，次数)

%%ets read-write 属性
-define(ETSRC,{read_concurrency,true}).
-define(ETSWC,{write_concurrency,true}).

%%tcp_server监听参数
-define(TCP_OPTIONS, [binary, {packet, 0}, {active, false}, {reuseaddr, true}, {nodelay, false}, {delay_send, true}, {send_timeout, 5000}, {keepalive, true}, {exit_on_close, true}]).
-define(RECV_TIMEOUT, 5000).


%% ---------------------------------
%% Logging mechanism
%% Print in standard output
-define(PRINT(Format, Args),
  io:format(Format, Args)).
-define(TEST_MSG(Format, Args),
  logger:test_msg(?MODULE,?LINE,Format, Args)).
-define(DEBUG(Format, Args),
  logger:debug_msg(?MODULE,?LINE,Format, Args)).
-define(INFO_MSG(Format, Args),
  logger:info_msg(?MODULE,?LINE,Format, Args)).
-define(WARNING_MSG(Format, Args),
  logger:warning_msg(?MODULE,?LINE,Format, Args)).
-define(ERROR_MSG(Format, Args),
  logger:error_msg(?MODULE,?LINE,Format, Args)).
-define(CRITICAL_MSG(Format, Args),
  logger:critical_msg(?MODULE,?LINE,Format, Args)).

-define(ETS_ONLINE, ets_online).								%% 本节点在线玩家

