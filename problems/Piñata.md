# The Piñata Problem

    You are riding a piñata on the surface of a circle of some integer circumference (C).
    The piñata only jumps, and it only jumps some integer length (L).
    At every jump, the piñata drops a single candy at some point (P) during the jump. (0 <= P < L)
    If a candy lands on another candy they annihilate each other and emit a photon.
    Will you ever land on a candy, and if so, how many jumps (H) will it take?

* `(C=10, L=2, P=1)` diverges.
* `(C=10, L=7, P=3, H=9)`
* `H < C`
* `H*L % C = P`
* `H = Pogo(C=C, D=P, L=L)`

When jumping over the edge of the circle, that is, when the total length you have jumped passes a multiple of `C`, let `O` be how much you overshot the edge by. Because you can only jump in increments of `L`, `0 <= O < L`.

The only way to land on a candy is if `O ϵ [P, P+O' % L]` where `O'` is the set of past overshots. It takes `C/L` jumps to get over the edge and there are `L` ways to overshoot, so `H < C/L*L` or `H < C`.

This also shows that `H*L % C = P`, which means that `H = Pogo(C=C, D=P, L=L)`. In other words, Piñata is a more restricted Pogo where `D < L`.
