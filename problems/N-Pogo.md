# N-Pogo

Let N-Pogo be the decision problem for whether a pogo stick that can choose between `N` different jump lengths must diverge. N-pogo is still decidable as there are only a finite number of states that it can be in, where a state is defined as being in spot `A` and choosing jump length `B`.

* `H < C^N!`
* `1-Pogo == Pogo` where we only care about divergence.

N-pogo can be solved recursively like so:

    let K be the set of jump lengths 1-Pogo(L1..LN) that does not diverge.
    iff K is empty or all N-Pogo (D = abs(D-Ki)) diverges, then we diverge.
    otherwise there is a solution.
