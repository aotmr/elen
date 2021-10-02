\ Stack operators

:swap over >r nip r> ;
:rot >r swap r> swap ;

\ Combinators

:dip swap >r call r> ;
:sip over >r call r> ;
:bi [ sip ] dip call ;
:bi* [ dip ] dip call ;
:bi@ dup bi* ;
:tri swap >r [ sip ] dip sip r> call swap ;