\
\ Cons Cell Wordset
\

:2align here 1 and 0= ?exit 0 , ;

:(cons)  here  &2, dip ;
:cons  2align  (cons) ;

:car @ ;
:cdr 1 + @ ;
:carcdr 2@ ;

:null? 0= ;
:atom? &string? [ 1 and 0<> ] &null? tri or or ;
:pair? atom? 0= ;

:>atom 2* 1+ ;
:atom> 1- 2/ ;

\ Build a null-terminated list of cons cells. The list is built from the stack
\ in reverse, using ( as the sentinel value. Building the list (a b c) would
\ look like this:
\
\   '( 'a 'b 'c )list
\
\ We can nest these list definitions arbitrarily.
\
\   '( 'a 'b 'c '( 'e 'f )list )list
\
\ The use of '( as a sentinel value precludes its inclusion in the list. 
\
\ ( ...items -- cell )
:(build-list) over '( = ?exit (cons) &(build-list) goto ;
:)list 2align 0 (build-list) nip ;

\ :)list 2align 0 [ '( = ] &cons while ;