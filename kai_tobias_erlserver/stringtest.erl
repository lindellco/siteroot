-module(stringtest).
-export([find_in_string/1]).


find_in_string([Hi, Hj|T]) ->
	case [Hi, Hj] of
		[120, 61] -> record_string(T);
		_ -> find_in_string([Hj, hd(T)|tl(T)]) end.
		
record_string([H|T]) ->
	case H of
		38 -> [];
		X -> [H] ++ record_string(T)
	end.