# PogoOmega

PogoOmega is the pogo problem that is equivalent to BoolFuck. Because BoolFuck is turing-complete, PogoOmega is undecidable.

BrainFuck was inspired by P'', which is almost equivalent except that it does not allow backwards jumping. P'' has been proven turing-complete, therefor BrainFuck is also turing-complete without back jumping, which means that BoolFuck is too.
Therefor PogoOmega does not need to support bi-directional jumps.

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

BrainFuck can be directly translated to BoolFuck by using the substitutions in the table below:

| BrainFuck | BoolFuck                                                  |
|-----------|-----------------------------------------------------------|
| `+`       | `>[>]!<[!<]>>>>>>>>>[!]<<<<<<<<<`                         |
| `-`       | `>>>>>>>>>!<<<<<<<<![>!]<[<]>>>>>>>>>[!]<<<<<<<<<`        |
| `<`       | `<<<<<<<<<`                                               |
| `>`       | `>>>>>>>>>`                                               |
| `[`       | `>>>>>>>>>!<<<<<<<<![>!]<[<]>>>>>>>>>[!<<<<<<<<[>]!<[!<]` |
| `]`       | `>>>>>>>>>!<<<<<<<<![>!]<[<]>>>>>>>>>]<[!<]`              |
