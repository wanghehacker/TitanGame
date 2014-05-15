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

