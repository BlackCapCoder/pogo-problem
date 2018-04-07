# N-SeqPogo'

This is a more restrictive version of [N-SeqPogo](N-SeqPogo.md). Like [N-SeqPogo](N-SeqPogo.md) it sequentially chooses jump lengths `L` from a list of length `N`, but it has to land on the candy after the last jump in the sequence.

* `(C=10, D=2, L=[7,2,9], H=12)`
* `(C=10, D=2, L=[2,3])` diverges
* `N-SeqPogo' == Pogo (sum L) * N`
* `H < C*N`
