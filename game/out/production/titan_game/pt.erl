%%%-------------------------------------------------------------------
%%% @author wanghe
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%% 协议公共函数
%%% @end
%%% Created : 19. 五月 2014 16:23
%%%-------------------------------------------------------------------
-module(pt).
-author("wanghe").

-include("common.hrl").
-include("record.hrl").

%% API
-export([read_string/1, pack/2]).

%%读取字符串
read_string(Bin) ->
  case Bin of
    <<Len:16, Bin1/binary>> ->
      case Bin1 of
        <<Str:Len/binary-unit:8, Rest/binary>> ->
          {binary_to_list(Str), Rest};
        _R1 ->
          {[], <<>>}
      end;
    _R1 ->
      {[], <<>>}
  end.

pack(Cmd, Data) ->
  L = byte_size(Data) + 6,
  <<L:32, Cmd:16, Data/binary>>.
