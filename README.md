# Elen - Forth-Inspired Meta Language

## Introduction

Elen is a stack programming language intended for researching
concepts not limited to metaprogramming, logic programming, and language design.

The interpreter is currently implemented in GNU Awk
for no particular reason other than that its facilities suffice for doing so.
This indeed means Elen is an interpreter running in an interpreted language.
Future versions of the interpreter may be written in a compiled language
if this becomes an issue.

[Lith](https://github.com/aotmr/Lith) has succeeded Elen as my current meta environment project.
If that goes well,
you are unlikely to see further changes to this repository.

## Design

### Primitives

Elen is a token-threaded interpreter.
Primitive words are encoded as strings,
and secondary words,
or words defined in terms of other primitives and secondaries,
are encoded as their code address.
Not all strings represent executable primitives;
the interpreter will panic if it tries to execute these.
This table of primitives is currently incomplete
and it will be changing often in the current stages of the project.

| Category | Name | Arity | Description
|-|-|-|-
| control flow | `exit` | ( -- ) | return to the calling definition
| | `?exit` | ( flag -- ) | return to the calling definition if flag is true
| | `goto` | ( addr -- ) | tail call the destination on the stack
| literal | `lit` #value | ( -- val ) | push a literal to the data stack
| | `quot` #len | ( -- a ) | push the quotation address and skip over it
| dictionary | `bind` | ( x name -- ) | assign value to name in dictionary
| | `find` | ( name -- val flag ) | find value for name in dictionary, flag indicates success
| | `type` | ( val -- type ) | replace the top stack value with its type: `'number` or `'string` |
| | `=` | ( a b -- a==b ) | test whether the top two items on the stack are equal
| | `,` | ( x --  ) | write a value to into dictionary space
| | `here` | ( -- addr ) | push the dictionary space pointer
| input, output | `.` | ( x -- ) | print the top stack value
| | `.s` | ( -- ) | print the full data stack
| | `cr ` | ( ) | print a carriage return
| arithmetic, logic | `+` | ( a b -- a+b ) | add the top two elements of the stack
| | `-` | ( a b -- a-b ) | subtract the top two elements of the stack
| | `*` | ( a b -- a\*b ) | multiply the top two elements of the stack
| | `/mod` | ( a b -- a/b a%b ) | divide the top two stack elements, giving the quotient and remainder
| | `neg` | ( a -- -a ) | negate the top item of the stack
| | `2/` | ( a -- a/2 ) | divide the top of stack element by two
| | `0=` | ( a -- flag ) | test if top of stack is equal to zero
| | `0<` | ( a -- flag ) | test if top of stakc is less than zero
| | `and` | ( a b -- a&b ) | bitwise and of top two stack elements
| | `or` | ( a b -- a\|b ) | bitwise or of top two stack elements
| stack manipulation | `dup` | ( a -- a a ) | duplicate top stack item
| | `over` | ( a b -- a b a ) | copy second stack item to top
| | `drop` | ( a -- ) | discard top stack item
| | `nip` | ( a b -- b ) | discard second stack item
| | `>r` | ( x -- R:x ) | transfer value from return to data stack
| | `r>` | ( R:x -- x ) | transfer values from data to return stack
| | `r@` | ( R:x -- R:x x ) | copy top item from return to data stack
| memory access | `>a` | ( addr -- ) | transfer top of stack to A
| | `a>` | ( -- addr ) | push value of A to stack
| | `a@+` | ( -- x ) | read memory at A and increment A
| | `a!+` | ( x -- ) | write to memory at A and increment A


### Control flow

`goto` provides for an explicit tail call mechanism.

Return stack manipulation gives us a sort of decorator mechanism
where we can use the tail end of a word
(everything to the right until the next `exit`)
as a quotation.
`?exit` is perhaps the most basic of these:
it either executes the rest of whatever word it is in,
or it doesn't.

Here is an example of the `times>` decorator.
It repeats the tail of a word
as many times as the top stack item.
Here are both the colon-definition and bind-definiton forms as well.
```
:say times> dup . 'more_times . cr ;
5 say

5 [ times> dup . 'more_times . cr ] call
```

Elen has conditional control flow with a single primitive: `?exit`.
With this primitive and the power of quotations,
we can derive a full set of conditional combinators.

### Code Generation

The secondary `constant` is a prime example of extending the interpreter
through dynamic compilation.
Given a name and a value,
`constant` compiles the value as a literal,
compiles an `exit` instruction,
and binds the address of this code to the name.
Since constants are functions,
we can select even between them with combinators.

## Future Plans

- [ ] **Machine code backend**
- [ ] **Self hosting**
- [ ] Constants, variables
- [ ] String operations
- [ ] **Control flow** - secondary words for selection and iteration
- [ ] Finish primitives
- [ ] Flesh out core words
- [ ] Cons cell heap

## Acknowledgements

- **RetroForth**, for its sigil-based syntax and combinators
- **pForth**, for the design of its token-threaded inner interpreter
