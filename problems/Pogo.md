# The Pogo Problem

    You are standing on a pogo stick at the surface of a circle with some integer circumferance (C).
    Some integer distance away from you (D) is a piece of candy.
    Your pogo stick can only jump in one direction, and only some specific integer length (L).
    How many jumps (H) does it take to land on the candy?

* `(C=10, D=1, L=2)` diverges.
* `H < C`


```
let T be the number of times passed all the way around the circle
D = H*L - T*C
```

The pogo problem is equivalent to finding the first positive integer solution to the linear equation `lh - ct = d`, which is solvable in `O(log c)` time with the euclidean algorithm.
