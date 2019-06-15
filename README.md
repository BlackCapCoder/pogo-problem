# Pogo

The [pogo problem](problems/Pogo.md) is a problem that I discovered while working on an optimizing BrainFuck compiler; it is a simplified model of how loops work in BrainFuck.

This repository is my effort to optimize and expand on the pogo problem to see how close I can get to solving the halting problem.

Descriptions of the problems in plain English can be found in the [problems](problems/) directory.


## Vocabulary

* All of the problems can not have a solution. If this is the case I say that it `diverges`.

# Update - Retrospective Summary/Conclusion

My "pogo problem" is a brief textual math problem. I found that any [smallfuck](https://esolangs.org/wiki/Smallfuck) program (a bitwise brainfuck derivative) can be turned into an equivallent pogo problem. The pogo problem can be solved in logarithmic time using the [extended euclidian algorithm](https://en.wikipedia.org/wiki/Extended_Euclidean_algorithm).

Smallfuck is turing-complete, so the actual problem then, must be the conversion. This is indeed the case. I found a general way to convert any smallfuck problem into a pogo problem, as long as it does not contain loops within loops. This much be what makes fucktoid languages turing-complete.

The code in this repository is a mess, I think some of it is wrong, and I'd recommend against reading it. Instead, have a look at [this gist](https://gist.github.com/BlackCapCoder/5bdba9e58ad48bd73cd74a05763de8a0) (written in C) which acts as a concise summary of the majority of this project.
