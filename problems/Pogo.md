# The pogo problem

    You are standing on a pogo stick at the surface of a circle with some integer circumferance (C).
    Some integer distance away from you (D) is a piece of candy.
    Your pogo stick can only jump in one direction, and only some specific integer length (L).
    How many jumps (H) does it take to land on the candy?

* `(C=10, D=1, L=2)` diverges.
* `H < C`

### Decidability

The pogo problem is obviously decidable. All you have to do to prove divergence is to simulate `C` hops. If no solution is found after `C` hops it cannot exist as there are only `C` spots on the circle, and you would have to revisit a spot where you have already been. The pogo stick has no memory or internal state, so if it lands on a spot where it has already been it must be in an infinite loop.

This is true even if there are more than one piece of candy.

------

    let T be the number of times passed all the way around the circle

    D = H*L - T*C
