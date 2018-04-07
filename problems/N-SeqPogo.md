# N-SeqPogo Problem

The N-SeqPogo problem is a more restrictive version of the [N-Pogo problem](N-Pogo.md). Like [N-Pogo](N-Pogo.md) the pogo stick has N different jump lengths, but it has to do them in sequence.

* `(C=10, D=1, L=[2,1], H=7)`
* `(C=10, D=1, L=[2,2,1])` diverges.
* `1-SeqPogo == Pogo`
* `H < C*N`


When jumping over the edge of the circle, that is, when the total length you have jumped `A` passes a multiple of `C`, let `O` be how much you overshot the edge by `O = A % C`.

Because `O < C` we know that there are only `C` different ways to overshoot the edge. After an overshoot we can be in any of the `N` different positions in the jump sequence, so we can say that the upper bound of `H` is `H < C*N`.
