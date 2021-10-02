\
\ Cons Cell Wordset
\

:2align here 1 and 0= ?exit 0 , ;

:cons  2align  here  &2, dip ;

:car @ ;
:cdr 1 + @ ;
:carcdr 2@ ;

:null? 0= ;
:atom? &string? [ 1 and 0<> ] &null? tri or or ;
:pair? atom? 0= ;

:>atom 2* 1+ ;
:atom> 1- 2/ ;