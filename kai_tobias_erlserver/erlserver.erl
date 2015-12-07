-module(erlserver).
-export([start/1, keyvaluepairs_to_jsonpair/1, concat_jsonpair/1, addfluff_to/2]).

start(Port) ->
    spawn(fun () -> {ok, Sock} = gen_tcp:listen(Port, [{active, false}]), 
                    loop(Sock) end).

loop(Sock) ->
    {ok, Conn} = gen_tcp:accept(Sock),
    Handler = spawn(fun () -> handle(Conn) end),
    gen_tcp:controlling_process(Conn, Handler),
    loop(Sock).

handle(Conn) ->
	gen_tcp:send(Conn, response(do_recv(Conn))),
    gen_tcp:close(Conn).

response(Str) ->	
    B = iolist_to_binary(Str),
    iolist_to_binary(
      io_lib:fwrite(
         "HTTP/1.0 200 OK\nContent-Type: text/html\nContent-Length: ~p\n\n~s",
         [size(B), B])).
		 

do_recv(Sock) ->
  case gen_tcp:recv(Sock, 0) of
    {ok, Bin} ->
    	

    	miner_data(self(), Bin),
    	
    	
    	receive
    		{ok, L, Ll} ->
    			Alist = L,
    			Blist = Ll,

    			%doDatabase_stuff(),
    			
    			A = concat_jsonpair(tl(Alist)),
				B = concat_jsonpair(tl(Blist)),
				addfluff_to(A, B)

    		after 15000 ->
    			ok 
    	end;
    	

    {error, timeout} ->
      	do_recv(Sock);
    {error, Reason} ->
      	exit(Reason)
   end.

%doDatabase_stuff() ->
%	X = your_mum.

miner_data(Pid, Bin) ->
	%io:format("~p~n", ["THE MINER HAS STARTED"]),
	X = lindellnco_hashtag_evaluator:evaluate_hashtag(find_in_string(Bin)),
	Y = lindellnco_hashtag_evaluator:evaluate_hashtag(find_in_string2(Bin)),

	%io:format("~p~n", ["THE MINES IS DONE AND IS ABOUT TO SEND!"]),
	Pid ! {ok, X, Y}.



find_in_string([Hi, Hj|T]) ->
	case [Hi, Hj] of
		[120, 61] -> record_string(T);
		_ -> find_in_string([Hj, hd(T)|tl(T)]) end.
		
record_string([H|T]) ->
	case H of
		38 -> [];
		_ -> [H] ++ record_string(T)
	end.
	
find_in_string2([Hi, Hj|T]) ->
	case [Hi, Hj] of
		[121, 61] -> record_string2(T);
		_ -> find_in_string2([Hj, hd(T)|tl(T)]) end.
		
record_string2([H|T]) ->
	case H of
		32 -> [];
		_ -> [H] ++ record_string2(T)
	end.
	
keyvaluepairs_to_jsonpair({A, B}) ->
	binary_to_list(iolist_to_binary(io_lib:format("{\"tag\":\"~p\", \"freq\":\"~p\"}", [A, B]))).


concat_jsonpair([{A, B}|[]]) ->
	keyvaluepairs_to_jsonpair({A, B});
concat_jsonpair([{A, B}|T]) ->
	keyvaluepairs_to_jsonpair({A, B})++","++concat_jsonpair(T).
	
	
addfluff_to(L, Ll) ->
	 io_lib:format("{\"X\":[~p], \"Y\":[~p]}", [L, Ll]).	
		