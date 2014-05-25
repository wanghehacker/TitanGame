%%%-------------------------------------------------------------------
%%% @author wanghe
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%% 服务器应用程序描述
%%% @end
%%% Created : 24. 五月 2014 20:00
%%%-------------------------------------------------------------------
{application, server, [
  {description, "This is game server"},
  {vsn, "1.0.0"},
  {registered, [ti_server_sup]},
  {applications, [
    kernel,
    stdlib,
    sasl
  ]},
  {mod, {ti_server_app, []}},
  {env,[{plantform,"mygame"},{server_num,1},{opening,1309773600}]},
  {start_phase, []}
]}.