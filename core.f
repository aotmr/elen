\
\ Constants
\

:true 1 ;
:false 0 ;

\
\ Stack operators
\

:2drop  drop drop ;
:swap over >r nip r> ;
:rot >r swap r> swap ;

\
\ Combinators
\
\ largely from https://gist.github.com/crcx/8060687#file-combinators-forth

:dip swap >r call r> ;
:sip over >r call r> ;
:bi [ sip ] dip call ;
:bi* [ dip ] dip call ;
:bi@ dup bi* ;
:tri swap >r [ sip ] dip sip r> call swap ;

\
\ Control flow
\

:?swap  ?exit swap ;

:choose  rot ?swap nip call ;

:if  [ ] swap choose ;
:-if  [ ] choose ;