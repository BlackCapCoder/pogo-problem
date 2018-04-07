# The Piñata Problem

    You are riding a piñata on the surface of a circle of some integer circumference (C).
    The piñata only jumps, and it only jumps some integer length (L).
    At every jump, the piñata drops a single candy at some point (P) during the jump. (0 <= P < L)
    If a candy lands on another candy they annihilate each other and emit a photon.
    Will you ever land on a candy, and if so, how many jumps (H) will it take?

* `(C=10, L=2, P=1)` diverges.
* `(C=10, L=7, P=3, H=9)`
* `H < C`

When you overshoot the edge of the circle you will have an overshot `0 <= O < L`. The only way to land on a candy is if `O ϵ [P, P+O' % L]` where `O'` is the set of past overshots.
It takes `C/L` jumps to get over the edge, so `H < C/L*L` or `H < C`

--------

This is a good time to mention BoolFuck, which is a language that is exactly like BrainFuck, except that it uses bits for memory rather than bytes. This fits better with my candy model. BrainFuck can be directly translated to BoolFuck like this:

| BrainFuck | BoolFuck                                                  |
|-----------|-----------------------------------------------------------|
| `+`       | `>[>]!<[!<]>>>>>>>>>[!]<<<<<<<<<`                         |
| `-`       | `>>>>>>>>>!<<<<<<<<![>!]<[<]>>>>>>>>>[!]<<<<<<<<<`        |
| `<`       | `<<<<<<<<<`                                               |
| `>`       | `>>>>>>>>>`                                               |
| `[`       | `>>>>>>>>>!<<<<<<<<![>!]<[<]>>>>>>>>>[!<<<<<<<<[>]!<[!<]` |
| `]`       | `>>>>>>>>>!<<<<<<<<![>!]<[<]>>>>>>>>>]<[!<]`              |

