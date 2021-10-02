:cons here >r 2, r> ;
:car @ ;
:cdr 1 + @ ;
:carcdr 2@ ;

:null? 0= ;
:atom? [ 1 and 0<> ] &null? bi or ;
:pair? atom? 0= ;