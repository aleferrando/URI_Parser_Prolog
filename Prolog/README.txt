Ferrando Alessandro 830405
Borgato Jacopo 866305

Il seguente README riguarda l’implementazione in Prolog di un parser per delle URI semplificate, ovvero una libreria che le rappresenti internamente partendo dalla loro rappresentazione come stringhe.

NB. La sintassi delle stringhe URI utilizzata in questo progetto è la seguente: 
- URI ::= URI1 | URI2
- URI1 ::= scheme ':' authorithy [‘/‘ [path]] [‘?’ query] [‘#’ fragment]
        |  scheme ‘:’ [‘/’] [path] [‘?’ query] [‘#’ fragment]
- URI2 ::= scheme ‘:’ scheme-syntax
Dove scheme, authority, path, query, fragment, scheme-syntax sono definiti nel testo del progetto.


Il programma consiste nei seguenti predicati:

%% uri_parse/2  predicato principale che scorpora la stringa nei vari campi dell’URI

%% check_scheme/1 controlla se scheme è di un tipo speciale

%% parse_scheme/3  richiama parse_scheme/4

%% parse_scheme/4 parsa la parte scheme e ridando anche il resto della stringa da parsare

%% parse_authorithy/5 controlla se c’è o meno authorithy. Se c’è chiama i predicati per parsare i vari campi di authorithy

%% parse_struct/4 chiama i predicati per parsare i restanti campi dopo authorithy in base a controlli sulla presenza di ‘/‘

%% parse_struct1/4 chiama i predicati per parsare i restanti campi dopo authorithy in base a controlli sulla presenza di ‘/‘

%% check_authorithy/3 controlla se authorithy c’è o meno

%% parse_struct1_zos/4 chiama i predicati per parsare i restanti campi dopo authorithy in base a controlli sulla presenza di ‘/‘ nel caso di scheme = zos

%% parse_struct_zos/4 chiama i predicati per parsare i restanti campi dopo authorithy in base a controlli sulla presenza di ‘/‘ nel caso di scheme = zos

%% parse_news/2 parsa gli URI con scheme = news 

%% parse_mailto/3 parsa gli URI con scheme = mailto

%% parse_host_mailto/2 parsa l’host con scheme = mailto 

%% parse_userinfo_mailto/3 chiama parse_userinfo_mailto/4

%% parse_userinfo_mailto/4 parsa userinfo con scheme = mailto

%% parse_userinfo_tel_fax/2 richiama parse_userinfo_mailto

%% parse_path_zos/3 fa alcuni controlli e richiama parse_path_zos/5

%% parse_path_zos/5 parsa il path per gli scheme “zos”

%% parse_id8/5 parsa id8

%% parse_userInfo/3 richiama parse_userInfo/4

%% parse_userInfo/4 parsa lo userinfo

%% parse_host/3 richiama parse_host/4

%% parse_host/4 parsa l’host

%% parse_port/3 fa alcuni controlli e chiama parse_port/4

%% parse_port/4 parsa la port

%% parse_path/3 chiama parse_path/4

%%parse_path/4 parsa il path

%% parse_query/3 chiama parse_query/4

%% parse_query/4 parsa la query

%% parse_fragment/2 chiama parse_fragment/2

%% parse_fragment/3 parsa il fragment

%% notMember/2 controlla che un elemento non sia in una lista

%% reverse/2 da una lista al contrario

%% controlla_caratteri/1 controlla che non sia un certo carattere

%% controlla_caratteri_aux/2 controlla che non sia un certo carattere

%% controlla_caratteri_host/1 controlla che non sia un certo carattere

%% controlla_caratteri_query/1 controlla che non sia un certo carattere

%% controlla_caratteri_zos/1 controlla che non sia un certo carattere

%% not_alphanum/1 controlla che non sia un alfanumerico

%% not/1  implementazione di not

%% is_my_digit/1  controlla sia un digit

%% is_not_digit/1 controlla non sia un digit

%% parse_IP/3 chiama parse_IP/6

%% parse_IP/6 parsa un IP

%% check_parse_IP/1 chiama check_parse_IP_aux/1

%% check_parse_IP_aux/1 fa dei controlli sull’IP

%% uri_display/1 stampa un uri in formato testuale

%% uri_display/2 stampa un uri in formato testuale su un determinato stream


