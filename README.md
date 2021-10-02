# Elen - Forth-Inspired Meta Language

## Introduction

Elen is a stack programming language intended for researching
concepts not limited to metaprogramming, logic programming, and language design.

The interpreter is currently implemented in GNU Awk
for no particular reason other than that its facilities suffice for doing so.
This indeed means Elen is an interpreter running in an interpreted language.
Future versions of the interpreter may be written in a compiled language
if this becomes an issue.

## Design

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

## Future Plans

- [ ] Constants, variables
- [ ] String operations
- [ ] Control flow
- [ ] Finish primitives
- [ ] Flesh out core words
- [ ] Cons cell heap

## Acknowledgements

- **RetroForth**, for its sigil-based syntax and combinators
- **pForth**, for the design of its token-threaded inner interpreter