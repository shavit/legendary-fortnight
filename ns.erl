-module(ns).

-export([start/0,
  store/2,
  lookup/1]).

start() ->
  register(ns, spawn(fun() -> loop() end)).

store(Key, Value) ->
    rpc({store, Key, Value}).

lookup(Key) -> rpc({lookup, Key}).

rpc(Q) ->
  ns ! {self(), Q},
    receive {ns, Reply} ->
      Reply
    end.

loop() ->
  receive
    {From, {store, Key, Value}} ->
      put(Key, {ok, Value}),
      From ! {ns, true},
        loop();
    {From, {lookup, Key}} ->
      From ! {ns, get(Key)},
        loop()
  end.
