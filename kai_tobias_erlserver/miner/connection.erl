-module(connection).

-export([start/0, get_db/2, test/0, make_doc/2, get_freq/3, get_value/3, get_hashtags/2]).


start() ->
	application:start(mimerl),
	application:start(certifi),
	hackney:start(),
	application:start(couchbeam),
	Url = "hal2000.skip.chalmers.se:1983",
	Options = [],
	S = couchbeam:server_connection(Url, Options),
	S.

create_db(S,Name) -> 
	
	Options = [],
	
	Result = couchbeam:create_db(S, Name, Options),
	
	case Result of 
		{ok, Db} ->
			
			{ok, Db};
		{error,Error} -> 
			
			
			{error,Error};
		Error ->
			
			
			{unkown_response,Error}
	end.
	
open_db(S,Name)-> 
	Options = [],
	{ok, Db} = couchbeam:open_db(S, Name, Options),
	{ok,Db}.

get_db(S,Name)->
	
	Response = create_db(S,Name),
	
	case Response of
		{ok, Db} -> 
			
			{ok,Db};
		{error,db_exists} -> 
			
			{ok, Db} = open_db(S, Name),
			{ok,Db};
		{error,Error} -> 
			
			
			{error,Error}
	end.

make_doc(Db, Doc) -> 
	%io:format("DOC: ~p~n",[Doc]),
	%io:format("~p~n", [
		couchbeam:save_doc(Db, Doc)
	%])
	.

get_doc(Db, Id) ->
	R = couchbeam:open_doc(Db, Id),
	io:format("R: ~p~n",[R]).

get_freq(Db, Xl, Yl) ->
	X = list_to_binary(Xl), Y = list_to_binary(Yl),  
	%io:format("~p  &  ~p ~n",[X,Y]),
	DesignName = {<<"pair_to_freq">>, <<"pair_to_freq">>},
	{ok, ViewResults} = couchbeam_view:fetch(Db, DesignName, [{key,[X,Y]}]),
	%io:format("ViewResults:~p~n ",[ViewResults]),
	Freq = get_value([X,Y],ViewResults,<<"0">>),
	case Freq of
		{_,<<"0">>} -> io:format("!");
		_ -> io:format("Freq:~p~n ",[Freq])
	end,
	Freq.

get_value(_,[],Def) -> {<<"-1">>, Def};
get_value(Key,[
	{[
		{<<"id">>,ID},
	    {<<"key">>,Key},
	    {<<"value">>,Val}
     ]}
     |_],_Def)->{ID, Val};
get_value(Key,[_|T],Def) ->get_value(Key,T,Def).

	

test() -> 
	
	S = start(),
	
	{ok, Db} = get_db(S,"testymctest4"),
	
	io:format(":::~n~p~n",[Db]),
	Doc = {[
		{<<"_id">>, <<"test">>},
		{<<"content">>, <<"some  changed text">>}
	]},
	
	make_doc(Db,Doc),
	
	ok.

get_hashtags(Db, Hash) ->
	DesignName = {<<"hash_to_hash">>, <<"hash_to_hash">>},
	{ok, ViewResults} = couchbeam_view:fetch(Db, DesignName, [{key,Hash}]),
	[{H,F} ||  {[_,_,{_,{[{_,H},{_,F}]}}]} <- ViewResults].