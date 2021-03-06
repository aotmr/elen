\
\ Math
\

:0> 0< 0= ;
:0<> 0= 0= ;

:1+ 1 + ;
:1- 1 - ;
:2* dup + ;

:*/ >r * r> /mod drop ;
:/ /mod drop ;
:mod /mod nip ;

:< - 0< ;
:> - 0> ;

\
\ Stack operators
\

:2drop  drop drop ;
:swap over >r nip r> ;
:rot >r swap r> swap ;

\
\ Memory access
\

:@ >a a@+ ;
:! >a a!+ ;

:2@ >a a@+ a@+ ;
:2! >a a!+ a!+ ;

:2, over , nip , ;

\
\ Combinators
\
\ largely from https://gist.github.com/crcx/8060687#file-combinators-forth

:dip swap >r call r> ;
:sip over >r call r> ;
:bi [ sip ] dip call ;
:bi* [ dip ] dip call ;
:bi@ dup bi* ;

\ Call the quotes f, g, and h with x, leaving the result of each on the stack
\
\ ( x f g h -- )
:tri swap >r [ sip ] dip sip r> call swap ;

\
\ Variables
\

\ Binds a name to a function that pushes the given value to the stack
\
\ ( value 'name -- )
:constant here &lit , rot , &exit , swap bind ;

0 'false constant
1 'true constant

\
\ Control flow
\

:?swap  ?exit swap ;

\ Calls false or true execution token depending on the flag
\
\ ( flag false true -- )
:choose  rot ?swap nip call ;

\ Like choose, but does a goto instead of a call
\
\ ( flag false true -- )
:whereto rot ?swap nip goto ;

\ Call the token if the flag is true
\
\ ( flag token -- )
:if  [ ] swap choose ;

\ Opposite of -if
\
\ ( flag token -- )
:-if [ ] choose ;

\ Decorator to execute the rest of a function n times. The top item of the
\ stack counts to zero
\
\ ( n -- n' )
:times>  1 -  r@  over [ drop ] [ r> drop call &times> goto ] whereto ;

\
\ Types
\

:number? type 'number = ;
:string? type 'string = ;