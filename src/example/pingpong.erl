-module(pingpong).

-export([start_ping/1, start_pong/0,  ping/2, pong/0, test/0]).

test() ->
  start_pong(),
  start_ping(node()).

ping(0, Pong_Node) ->
  {pong, Pong_Node} ! finished,
  io:format("Ping finished~n", []);

ping(N, Pong_Node) ->
  {pong, Pong_Node} ! {ping, self()},
  receive
    pong ->
      io:format("Ping received pong~n", [])
  end,
  ping(N - 1, Pong_Node).

pong() ->
  receive
    finished ->
      io:format("Pong finished~n", []);
    {ping, Ping_PID} ->
      io:format("Pong received ping~n", []),
      Ping_PID ! pong,
      pong()
  end.

start_pong() ->
  register(pong, spawn(pingpong, pong, [])).

start_ping(Pong_Node) ->
  spawn(pingpong, ping, [3, Pong_Node]).
