%%%-------------------------------------------------------------------
%%% @author wanghe
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 14. 五月 2014 21:03
%%%-------------------------------------------------------------------
{application, gateway, [
  {description, "This is game gateway"},
  {vsn, "1.0"},
  {registered, [ti_gateway_sup]},
  {applications, [
    kernel,
    stdlib,
    sasl
  ]},
  {mod, {ti_gateway_app, []}},
  {start_phase, []}
]}.