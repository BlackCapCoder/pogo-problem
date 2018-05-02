# N-SeqPiñata'

This is a more restrictive version of [N-SeqPiñata](N-SeqPiñata.md), and is the [Piñata](Piñata.md) dual to [N-SeqPogo'](N-SeqPogo'.md). Like [N-SeqPiñata](N-SeqPiñata.md) it sequentially chooses jump lengths `L` and drop points `P` from a list of length `N`, but it has to land on a candy after the last jump in the sequence.

* `(C=100, [(L=7, P=3), (L=8, P=5)], H=14)`
* `(C=100, [(L=7, P=3), (L=8, P=5), (L=5, P=1)])` diverges.

It is equivalent to [Piñata](Piñata.md) where we allow dropping multiple candies in a single jump.


