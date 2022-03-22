%%%% -*- Mode: Prolog -*- 

%% Ferrando Alessandro 830405
%% Borgato Jacopo 866305

%% uri_parse/2
uri_parse(URIString,
	  uri(Scheme, Userinfo, Host, Port, Path, Query, Fragment)) :-
    string_chars(URIString, CharList),
    parse_scheme(CharList, Scheme, Rest),
    check_scheme(Scheme),
    parse_authorithy(Rest, Userinfo, Host, Port, Rest1),
    check_authorithy(Userinfo, Host, Port),
    parse_struct1(Rest1, Path, Query, Fragment), !.

%% uri_parse/2
uri_parse(URIString,
	  uri(Scheme, Userinfo, Host, Port, Path, Query, Fragment)) :-
    string_chars(URIString, CharList),
    parse_scheme(CharList, Scheme, Rest),
    check_scheme(Scheme),
    parse_authorithy(Rest, Userinfo, Host, Port, Rest1),
    parse_struct(Rest1, Path, Query, Fragment), !.

uri_parse(URIString, uri(Scheme, Userinfo, Host, 80, [], [], [])) :-
    string_chars(URIString, CharList),
    parse_scheme(CharList, Scheme, Rest),
    Scheme == 'mailto',
    parse_mailto(Rest, Userinfo, Host), !.

uri_parse(URIString, uri(Scheme, [], Host, 80, [], [], [])) :-
    string_chars(URIString, CharList),
    parse_scheme(CharList, Scheme, Rest),
    Scheme == 'news',
    parse_news(Rest, Host), !.

uri_parse(URIString, uri(Scheme, Userinfo, [], 80, [], [], [])) :-
    string_chars(URIString, CharList),
    parse_scheme(CharList, Scheme, Rest),
    Scheme == 'tel',
    parse_userinfo_tel_fax(Rest, Userinfo), !.

uri_parse(URIString, uri(Scheme, Userinfo, [], 80, [], [], [])) :-
    string_chars(URIString, CharList),
    parse_scheme(CharList, Scheme, Rest),
    Scheme == 'fax',
    parse_userinfo_tel_fax(Rest, Userinfo), !.

uri_parse(URIString,
	  uri(Scheme, Userinfo, Host, Port, Path, Query, Fragment)) :-
    string_chars(URIString, CharList),
    parse_scheme(CharList, Scheme, Rest),
    Scheme == 'zos',
    parse_authorithy(Rest, Userinfo, Host, Port, Rest1),
    check_authorithy(Userinfo, Host, Port),
    parse_struct1_zos(Rest1, Path, Query, Fragment), !.

uri_parse(URIString,
	  uri(Scheme, Userinfo, Host, Port, Path, Query, Fragment)) :-
    string_chars(URIString, CharList),
    parse_scheme(CharList, Scheme, Rest),
    Scheme == 'zos',
    parse_authorithy(Rest, Userinfo, Host, Port, Rest1),
    parse_struct_zos(Rest1, Path, Query, Fragment), !.

%% check_scheme/1
check_scheme(X) :-
    atom_string(X, StringInput),
    string_upper(StringInput, Upper),
    atom_string(InputAtom, Upper),
    atom_string(Mailto, "MAILTO"),
    InputAtom \= Mailto,
    atom_string(News, "NEWS"),
    InputAtom \= News,
    atom_string(Tel, "TEL"),
    InputAtom \= Tel,
    atom_string(Fax, "FAX"),
    InputAtom \= Fax,
    atom_string(Zos, "ZOS"),
    InputAtom \= Zos.

%% parse_scheme/3 
parse_scheme(CharList, Scheme, Rest) :-
    parse_scheme(CharList, [], Scheme, Rest).

%% parse_scheme/4
parse_scheme([X | Xs], Zs, Scheme, Rest) :-
    controlla_caratteri(X),
    parse_scheme(Xs, [X | Zs], Scheme, Rest).
parse_scheme([X | Xs], Zs, Scheme, Xs) :-
    X == ':',
    Zs \= [],
    reverse(Zs, Rev),
    string_chars(Scheme1, Rev),
    atom_string(Scheme, Scheme1).

%% parse_authorithy/5
parse_authorithy([X1, X2 | CharList], Userinfo, Host, Port, Rest) :-
    X1 == '/',
    X2 == '/',
    parse_userInfo(CharList, Userinfo, Rest1),
    parse_host(Rest1, Host, Rest2),
    parse_port(Rest2, Port, Rest).
parse_authorithy([], [], [], 80, []).
parse_authorithy([X1, X2 | Charlist], [], [], 80, [X1, X2 | Charlist]) :-
    X2 \= '/'.
parse_authorithy([X1 | Charlist], [], [], 80, [X1 | Charlist]) :-
    Charlist == [].

%% parse_struct/4
parse_struct([], [], [], []).
parse_struct([X | Xs], [], [], []) :- 
    X == '/',
    Xs == [].
parse_struct([X | CharList], Path, Query, Fragment) :-
    X == '/',
    parse_path(CharList, Path, Rest1),
    parse_query(Rest1, Query, Rest),
    parse_fragment(Rest, Fragment).
parse_struct([X | CharList], [], Query, Fragment) :-
    X \= '/',
    parse_path([X | CharList], Path, Rest1),
    Path == [], 
    parse_query(Rest1, Query, Rest),
    parse_fragment(Rest, Fragment).

%% parse_struct1/4
parse_struct1([], [], [], []).
parse_struct1([X | Xs], [], [], []) :- 
    X == '/',
    Xs == [].
parse_struct1([X | CharList], Path, Query, Fragment) :-
    X == '/',
    parse_path(CharList, Path, Rest1),
    parse_query(Rest1, Query, Rest),
    parse_fragment(Rest, Fragment).
parse_struct1([X | CharList], Path, Query, Fragment) :-
    X \= '/',
    parse_path([X | CharList], Path, Rest1),
    parse_query(Rest1, Query, Rest),
    parse_fragment(Rest, Fragment).

%% check_authorithy/3
check_authorithy(Userinfo, Host, Port) :-
    Userinfo == [],
    Host == [],
    Port == 80.

%% parse_struct1_zos/4
parse_struct1_zos([], [], [], []).
parse_struct1_zos([X | Xs], [], [], []) :- 
    X == '/',
    Xs == [].
parse_struct1_zos([X | CharList], Path, Query, Fragment) :-
    X == '/',
    parse_path_zos(CharList, Path, Rest1),
    parse_query(Rest1, Query, Rest),
    parse_fragment(Rest, Fragment).
parse_struct1_zos([X | CharList], Path, Query, Fragment) :-
    X \= '/',
    parse_path_zos([X | CharList], Path, Rest1),
    parse_query(Rest1, Query, Rest),
    parse_fragment(Rest, Fragment).

%% parse_struct_zos/4
parse_struct_zos([], [], [], []).
parse_struct_zos([X | Xs], [], [], []) :- 
    X == '/',
    Xs == [].
parse_struct_zos([X | CharList], Path, Query, Fragment) :-
    X == '/',
    parse_path_zos(CharList, Path, Rest1),
    parse_query(Rest1, Query, Rest),
    parse_fragment(Rest, Fragment).
parse_struct_zos([X | CharList], Path, Query, Fragment) :-
    X \= '/',
    parse_path_zos([X | CharList], Path, Rest1),
    Path == [],
    parse_query(Rest1, Query, Rest),
    parse_fragment(Rest, Fragment).

%% parse_news/2
parse_news(CharList, Host) :-
    parse_host(CharList, Host, Rest),  
    Rest == [].
parse_news([], []).

%% parse_mailto/3
parse_mailto(CharList, Userinfo, Host) :-
    parse_userinfo_mailto(CharList, Userinfo, Rest),
    Userinfo \= '',
    parse_host_mailto(Rest, Host).
parse_mailto([], [], []).

%% parse_host_mailto/2
parse_host_mailto([], []).
parse_host_mailto(CharList, Host) :-
    parse_host(CharList, Host, _).

%% parse_userinfo_mailto/3
parse_userinfo_mailto(CharList, Userinfo, Rest) :-
    parse_userinfo_mailto(CharList, [], Userinfo, Rest).

%% parse_userinfo_mailto/4
parse_userinfo_mailto([X | Xs], Zs, Userinfo, Rest) :-
    controlla_caratteri(X),
    parse_userinfo_mailto(Xs, [X | Zs], Userinfo, Rest).
parse_userinfo_mailto([], Zs, Userinfo, []) :-
    reverse(Zs, Rev),
    string_chars(Userinfo1, Rev),
    atom_string(Userinfo, Userinfo1).
parse_userinfo_mailto([X, Y | Xs], Zs, Userinfo, [Y | Xs]) :-
    X == '@',
    controlla_caratteri_host(Y),
    reverse(Zs, Rev),
    string_chars(Userinfo1, Rev),
    atom_string(Userinfo, Userinfo1).

%% parse_userinfo_tel_fax/2
parse_userinfo_tel_fax([], []).
parse_userinfo_tel_fax(CharList, Userinfo) :-
    parse_userinfo_mailto(CharList, Userinfo, []).

%% parse_path_zos/3
parse_path_zos([X | CharList], Path, Rest) :-
    char_type(X, alpha),
    parse_path_zos(CharList, [X], 0, Path, Rest).
parse_path_zos([X | CharList], [], [X | CharList]) :-
    X == '#'.
parse_path_zos([X | CharList], [], [X | CharList]) :-
    X == '?'.

%% parse_path_zos/5
parse_path_zos([X | Xs], Zs, Cont, Path, Rest) :-
    controlla_caratteri_zos(X),
    Cont1 is Cont + 1,
    Cont1 =< 43,
    parse_path_zos(Xs, [X | Zs], Cont1, Path, Rest).
parse_path_zos([X, Y | Xs], Zs, Cont, Path, Rest) :-
    X == '.',
    controlla_caratteri_zos(Y),
    Cont1 is Cont + 1,  %% IL '.' CONTA NELLA LUNGHEZZA DI id44
    Cont1 =< 43,
    parse_path_zos([Y | Xs], [X | Zs], Cont1, Path, Rest).
parse_path_zos([], Zs, _, Path, []) :-  
    reverse(Zs, Rev),
    string_chars(Path1, Rev),
    atom_string(Path, Path1).
parse_path_zos([X | Xs], Zs, _, Path, [X | Xs]) :- 
    not_alphanum(X),
    reverse(Zs, Rev),
    string_chars(Path1, Rev),
    atom_string(Path, Path1).
parse_path_zos([X, Y | Xs], Zs, _, Path, Rest) :- 
    X == '(',
    char_type(Y, alpha),
    reverse([X | Zs], Path1),
    parse_id8([Y | Xs], [], 0, Path2, Rest),
    append(Path1, Path2, Path3),
    string_chars(Path11, Path3),
    atom_string(Path, Path11).

%% parse_id8/5
parse_id8([X | Xs], Zs, Cont, Path, Rest) :-
    controlla_caratteri_zos(X),
    Cont1 is Cont + 1,
    Cont1 =< 8,
    parse_id8(Xs, [X | Zs], Cont1, Path, Rest).
parse_id8([X | Xs], Zs, _, Path, Xs) :- 
    X == ')',
    reverse([X | Zs], Path).


%% parse_userInfo/3
parse_userInfo(CharList, [], CharList) :-  
    notMember('@', CharList).
parse_userInfo(CharList, Userinfo, Rest) :-
    parse_userInfo(CharList, [], Userinfo, Rest).

%% parse_userInfo/4
parse_userInfo([X | Xs], Zs, Userinfo, Rest) :-
    controlla_caratteri(X),
    parse_userInfo(Xs, [X | Zs], Userinfo, Rest).
parse_userInfo([X | Xs], Zs, Userinfo, Xs) :-
    X == '@',
    Zs \= [],
    reverse(Zs, Rev),
    string_chars(Userinfo1, Rev),
    atom_string(Userinfo, Userinfo1).
parse_userInfo([X | Xs], Zs, [], Rest) :-   
    X \= '@',
    reverse(Zs, Rev),
    append(Rev, [X | Xs], Rest).

%% parse_host/3
parse_host([X | CharList], Host, Rest) :-
    controlla_caratteri_host(X),
    parse_host([X | CharList], [], Host, Rest).
parse_host([X | CharList], Host, Rest) :-
    is_my_digit(X),
    parse_host([X | CharList], [], Host, Rest).

%% parse_host/4
parse_host([X | Xs], _, Host, Rest) :- 
    parse_IP([X | Xs], Host, Rest).
parse_host([X | Xs], Zs, Host, Rest) :-
    controlla_caratteri_host(X),
    parse_host(Xs, [X | Zs], Host, Rest).
parse_host([X, Y | Xs], Zs, Host, Rest) :- 
    X == '.',
    controlla_caratteri_host(Y),
    parse_host([Y | Xs], [X | Zs], Host, Rest).
parse_host([X | Xs], Zs, Host, [X | Xs]) :- 
    X == ':',
    reverse(Zs, Rev),
    string_chars(Host1, Rev),
    atom_string(Host, Host1). 
parse_host([X | Xs], Zs, Host, [X | Xs]) :-
    X == '/',
    reverse(Zs, Rev),
    string_chars(Host1, Rev),
    atom_string(Host, Host1).
parse_host([X | Xs], Zs, Host, [X | Xs]) :-
    X == '?',
    reverse(Zs, Rev),
    string_chars(Host1, Rev),
    atom_string(Host, Host1).
parse_host([X | Xs], Zs, Host, [X | Xs]) :-
    X == '#',
    reverse(Zs, Rev),
    string_chars(Host1, Rev),
    atom_string(Host, Host1).
parse_host([], Zs, Host, []) :-
    reverse(Zs, Rev),
    string_chars(Host1, Rev),
    atom_string(Host, Host1).


%% parse_port/3
parse_port([], 80, []).
parse_port([X | List], 80, [X | List]) :-
    X \= ':'.  
parse_port([X, Y | CharList], Port, Rest) :-
    X == ':',
    is_my_digit(Y),
    parse_port([Y | CharList], [], Port, Rest).

%% parse_port/4
parse_port([X | Xs], Zs, Port, Rest) :-
    is_my_digit(X),
    parse_port(Xs, [X | Zs], Port, Rest).
parse_port([X | Xs], Zs, Port, [X | Xs]) :-
    is_not_digit(X),
    reverse(Zs, Rev),
    string_chars(Port1, Rev),
    number_string(Port, Port1).
parse_port([], Zs, Port, []) :-
    reverse(Zs, Rev),
    string_chars(Port1, Rev),
    number_string(Port, Port1).

%% parse_path/3
parse_path([], [], []).
parse_path([X | CharList], [], [X | CharList]) :-
    X == '?'.
parse_path([X | CharList], [], [X | CharList]) :-
    X == '#'.
parse_path(CharList, Path, Rest) :-
    parse_path(CharList, [], Path, Rest).

%%parse_path/4
parse_path([X | Xs], Zs, Path, Rest) :-
    controlla_caratteri(X),
    parse_path(Xs, [X | Zs], Path, Rest).
parse_path([X, Y | Xs], Zs, Path, Rest) :-
    Zs \= [],
    X == '/',
    controlla_caratteri(Y),
    parse_path([Y | Xs], [X | Zs], Path, Rest).
parse_path([X, Y | Xs], Zs, Path, [Y | Xs]) :-
    Zs \= [],
    X == '/',
    Y == '?',
    reverse([X | Zs], Rev),
    string_chars(Path1, Rev),
    atom_string(Path, Path1).
parse_path([X, Y | Xs], Zs, Path, [Y | Xs]) :-
    Zs \= [],
    X == '/',
    Y == '#',
    reverse([X | Zs], Rev),
    string_chars(Path1, Rev),
    atom_string(Path, Path1).
parse_path([X | Xs], Zs, Path, []) :-
    Zs \= [],
    X == '/',
    Xs == [],
    reverse([X | Zs], Rev),
    string_chars(Path1, Rev),
    atom_string(Path, Path1).
parse_path([], Zs, Path, []) :-
    reverse(Zs, Rev),
    string_chars(Path1, Rev),
    atom_string(Path, Path1).
parse_path([X | Xs], Zs, Path, [X | Xs]) :-
    X == '?',
    reverse(Zs, Rev),
    string_chars(Path1, Rev),
    atom_string(Path, Path1).
parse_path([X | Xs], Zs, Path, [X | Xs]) :-
    X == '#',
    reverse(Zs, Rev),
    string_chars(Path1, Rev),
    atom_string(Path, Path1).

%% parse_query/3
parse_query([], [], []).
parse_query([X | CharList], [], [X | CharList]) :-
    X == '#'.
parse_query([X, Y | CharList], Query, Rest) :-
    X == '?',
    controlla_caratteri_query(Y), 
    parse_query([Y | CharList], [], Query, Rest).

%% parse_query/4
parse_query([X | Xs], Zs, Query, Rest) :-
    controlla_caratteri_query(X),
    parse_query(Xs, [X | Zs], Query, Rest).
parse_query([X | Xs], Zs, Query, [X | Xs]) :-
    X == '#',
    reverse(Zs, Rev),
    string_chars(Query1, Rev),
    atom_string(Query, Query1).
parse_query([], Zs, Query, []) :-
    reverse(Zs, Rev),
    string_chars(Query1, Rev),
    atom_string(Query, Query1).

%% parse_fragment/2
parse_fragment([], []).
parse_fragment([X | CharList], Fragment) :-
    X == '#',
    CharList \= [], 
    parse_fragment(CharList, [], Fragment).

%% parse_fragment/3
parse_fragment([X | Xs], Zs, Fragment) :-
    parse_fragment(Xs, [X | Zs], Fragment).
parse_fragment([], Zs, Fragment) :-
    reverse(Zs, Rev),
    string_chars(Fragment1, Rev),
    atom_string(Fragment, Fragment1).

%% notMember/2
notMember(_, []) :- !.
notMember(X, [Y | Ys]) :-
    X \= Y,
    notMember(X, Ys).

%% reverse/2
reverse(List, Rev) :-
    reverse(List, Rev, []).
reverse([], Z, Z).
reverse([H | T], Z, Acc) :-
    reverse(T, Z, [H | Acc]).

%% controlla_caratteri/1
controlla_caratteri(X) :-
    string_chars(":/?@#", BanList),
    controlla_caratteri_aux(X, BanList).

%% controlla_caratteri_aux/2
controlla_caratteri_aux(_, []).
controlla_caratteri_aux(X, [Y | Ys]) :-
    X \= Y,
    controlla_caratteri_aux(X, Ys).

%% controlla_caratteri_host/1
controlla_caratteri_host(X) :-
    string_chars("./?@#:", BanList),
    controlla_caratteri_aux(X, BanList).

%% controlla_caratteri_query/1
controlla_caratteri_query(X) :-
    string_chars("#", BanList),
    controlla_caratteri_aux(X, BanList).

%% controlla_caratteri_zos/1 
controlla_caratteri_zos(X) :-
    char_type(X, alnum).

%% not_alphanum/1
not_alphanum(X) :-
    not(char_type(X, alnum)).

%% not/1  
not(P) :- call(P), !, fail.
not(_).

%% is_my_digit/1 
is_my_digit(X) :-
    char_type(X,digit).

%% is_not_digit/1
is_not_digit(X) :-
    X \= '0',
    X \= '1',
    X \= '2',
    X \= '3',
    X \= '4',
    X \= '5',
    X \= '6',
    X \= '7',
    X \= '8',
    X \= '9'.

%% parse_IP/3
parse_IP(List, IP, Rest) :-
    parse_IP(List, [], 0, 0, IP, Rest),
    check_parse_IP(IP).
%% parse_IP/6
parse_IP([X | Xs], Zs, Cont, Cont2, IP, Rest) :-
    is_my_digit(X),
    Cont1 is Cont + 1,
    Cont3 is Cont2 + 1,
    Cont3 =< 3,
    Cont1 =< 12,
    parse_IP(Xs, [X | Zs], Cont1, Cont3, IP, Rest).
parse_IP([X, Y | Xs], Zs, Cont, _, IP, Rest) :- 
    X == '.',
    is_my_digit(Y),
    Cont =< 12,
    parse_IP([Y | Xs], [X | Zs], Cont, 0, IP, Rest).
parse_IP([X | Xs], Zs, Cont, _, IP, [X | Xs]) :- 
    is_not_digit(X),
    Cont == 12,
    reverse(Zs, Rev),
    string_chars(IP1, Rev),
    atom_string(IP, IP1).
parse_IP([], Zs, Cont, _, IP, []) :- 
    Cont == 12,
    reverse(Zs, Rev),
    string_chars(IP1, Rev),
    atom_string(IP, IP1).

%% check_parse_IP/1
check_parse_IP(IP) :-
    atom_string(IP, IPstring),
    string_chars(IPstring, IPlist),
    check_parse_IP_aux(IPlist).

%% check_parse_IP_aux/1
check_parse_IP_aux([]).
check_parse_IP_aux([X, Y, Z | Xs]) :-
    is_my_digit(X),
    is_my_digit(Y),
    is_my_digit(Z),
    string_chars(IPstring, [X, Y, Z]),
    number_string(IPnumber, IPstring),
    IPnumber =< 255,
    check_parse_IP_aux(Xs).
check_parse_IP_aux([X | Xs]) :-
    X == '.',
    check_parse_IP_aux(Xs).

%% uri_display/1
uri_display(Stringa) :-
    uri_parse(Stringa,
	      uri(Scheme, Userinfo, Host, Port, Path, Query, Fragment)),
    write("Scheme: "),
    write(Scheme),
    nl,
    write("Userinfo: "),
    write(Userinfo),
    nl,
    write("Host: "),
    write(Host),
    nl,
    write("Port: "),
    write(Port),
    nl,
    write("Path: "),
    write(Path),
    nl,
    write("Query: "),
    write(Query),
    nl,
    write("Fragment: "),
    write(Fragment).

%% uri_display/2
uri_display(Stringa, Stream) :-
    uri_parse(Stringa,
	      uri(Scheme, Userinfo, Host, Port, Path, Query, Fragment)),  
    write(Stream, "Scheme: "),
    write(Stream, Scheme),
    nl(Stream),
    write(Stream, "Userinfo: "),
    write(Stream, Userinfo),
    nl(Stream),
    write(Stream, "Host: "),
    write(Stream, Host),
    nl(Stream),
    write(Stream, "Port: "),
    write(Stream, Port),
    nl(Stream),
    write(Stream, "Path: "),
    write(Stream, Path),
    nl(Stream),
    write(Stream, "Query: "),
    write(Stream, Query),
    nl(Stream),
    write(Stream, "Fragment: "),
    write(Stream, Fragment).
