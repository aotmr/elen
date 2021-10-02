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