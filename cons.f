\ for our pointer tags to work, all cons cells
\ must be allocated aligned to even addresses
:cons-align here 1 and 0= ?exit 0 , ;

:cons cons-align here >r 2, r> ;

:car @ ;
:cdr 1 + @ ;
:carcdr 2@ ;

:null? 0= ;
:atom? [ 1 and 0<> ] &null? bi or ;
:pair? atom? 0= ;

:>atom 2* 1+ ;
:atom> 1- 2/ ;