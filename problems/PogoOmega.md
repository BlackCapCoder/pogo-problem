# PogoOmega

PogoOmega is the pogo problem that is equivalent to BoolFuck. Because BoolFuck is turing-complete, PogoOmega is undecidable.

BrainFuck was inspired by P'', which is almost equivalent except that it does not allow backwards jumping. P'' has been proven turing-complete, therefor BrainFuck is also turing-complete without back jumping, which means that BoolFuck is too.
Therefor PogoOmega does not need to support bi-directional jumps.

BrainFuck has been proven turing-complete with only 3 non-wrapping memory cells by reduction from collatz functions, by reduction from fractran. As such PogoOmega does not need to support `C` greater than `3*9`.

The code produced by the reduction also does not overshoot the circle edge, so this is not the behaviour that causes non-determinism.

## Pogo difficulty

The pogo difficulty is the kind of pogo problem a particular BoolFuck loop translates to.

```
[>>>]    Pogo
[>!>]    Piñata
[!>!>>]  2-SeqPiñata'

[ [>>>] [>> ] ]  2-SeqPogo
[ [>!>] [!>>] ]  2-SeqPiñata
```

-------

BrainFuck can be directly translated to BoolFuck by using the substitutions in the table below (IO has been omitted as it is not required for turing-completeness):

| BrainFuck | BoolFuck                                                  |
|-----------|-----------------------------------------------------------|
| `+`       | `>[>]!<[!<]>>>>>>>>>[!]<<<<<<<<<`                         |
| `-`       | `>>>>>>>>>!<<<<<<<<![>!]<[<]>>>>>>>>>[!]<<<<<<<<<`        |
| `<`       | `<<<<<<<<<`                                               |
| `>`       | `>>>>>>>>>`                                               |
| `[`       | `>>>>>>>>>!<<<<<<<<![>!]<[<]>>>>>>>>>[!<<<<<<<<[>]!<[!<]` |
| `]`       | `>>>>>>>>>!<<<<<<<<![>!]<[<]>>>>>>>>>]<[!<]`              |
