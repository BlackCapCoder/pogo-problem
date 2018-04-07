# Pogo

The pogo problem is a problem that I discovered while working on an optimizing BrainFuck compiler; it is a simplified version of how loops work in BrainFuck.
This repository is my effort to optimize and expand on the pogo problem to see how close I can get to solving the halting problem.

The pogo problem goes like this:

    You are standing on a pogo stick at the surface of a circle with some integer circumferance (C).
    Some integer distance away from you (D) is a piece of candy.
    Your pogo stick can only jump in one direction, and only some specific integer length (L).
    How many jumps (H) does it take to land on the candy?

Note that the pogo problem does not always have a solution. If this is the case it is said to diverge.
A simple example of an instance that diverges is `(C=10, D=1, L=2)`.

### Decidability

The pogo problem is obviously decidable. All you have to do to prove divergence is to simulate C hops. If no solution is found after C hops it cannot exist as there are only C spots on the circle, and you would have to revisit a spot where you have already been. The pogo stick has no memory or internal state, so if it lands on a spot where it has already been it must be in an infinite loop. `H < C`

This is true even if there are more than one piece of candy.

### N-Pogo

Let N-Pogo be the decision problem for whether a pogo stick that can choose between N different jump lengths must diverge. N-pogo is still decidable as there are only a finite number of states that it can be in, where a state is defined as being in spot A and choosing jump length B. `H < C^N!`

1-Pogo is equivalent to the regular pogo problem, except that we only care about divergence.

N-pogo can be solved recursively like so:

    let K be the set of jump lengths 1-Pogo(L1..LN) that does not diverge.
    iff K is empty or all N-Pogo (D = abs(D-Ki)) diverges, then we diverge.
    otherwise there is a solution.


# The Piñata Problem

    You are riding a piñata on the surface of a circle of some integer circumference (C).
    The piñata only jumps, and it only jumps some integer length (L).
    At every jump, the piñata drops a single candy at some point (P) during the jump. (0 <= P < L)
    If a candy lands on another candy they annihilate each other and emit a photon.
    Will you ever land on a candy, and if so, how many jumps (H) will it take?

* `(C=10, L=2, P=1)` diverges.
* `(C=10, L=7, P=3, H=9)`
* I have checked all problems `0 <= P < L < C < 100`, and there are no solutions where `H > C`. I strongly believe this to be true for all problems.

This is a good time to mention BoolFuck, which is a language that is exactly like BrainFuck, except that it uses bits for memory rather than bytes. This fits better with my candy model. BrainFuck can be directly translated to BoolFuck like this:

| BrainFuck | BoolFuck                                                  |
|-----------|-----------------------------------------------------------|
| `+`       | `>[>]!<[!<]>>>>>>>>>[!]<<<<<<<<<`                         |
| `-`       | `>>>>>>>>>!<<<<<<<<![>!]<[<]>>>>>>>>>[!]<<<<<<<<<`        |
| `<`       | `<<<<<<<<<`                                               |
| `>`       | `>>>>>>>>>`                                               |
| `[`       | `>>>>>>>>>!<<<<<<<<![>!]<[<]>>>>>>>>>[!<<<<<<<<[>]!<[!<]` |
| `]`       | `>>>>>>>>>!<<<<<<<<![>!]<[<]>>>>>>>>>]<[!<]`              |

