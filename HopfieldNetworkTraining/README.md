## Group A - Exercise 2

### Context
A [Hopfield Network](https://en.wikipedia.org/wiki/Hopfield_network) operates recurrently, as following:

- It consists of $N$ self-fed nodes-neurons, with 2 possible states: $+1$ & $-1$.
- We can store a number of $N$-dimensional vectors, with possible element values $+1$ & $-1$.
- When the network is fed with an $N$-dimensional vector, its state will eventually balance itself in one of the stored vectors, which is the closest to the given vector.


A Hopfield Network is trained by storing a number of $N$-dimensional vectors.
This storage is implemented by calculating the $N \times N$ weight vector of the network.

Each weight of the network is attached to a connection between 2 nodes. The weight matrix $W$ is calculated as following:

$$ W = \sum_{i=1}^M (Y^3_{i} \cdot Y_i) - M \cdot I $$

Where:
 - $M$ is the number of $N$-dimensional vectors
 - $Y_i$ is one of the $1 \times N$ vectors to be stored
 - $Y_i^T$ is the $N \times 1$ column vector (the reversed $Y_i$)
 - $I_n$ is the $N \times N$ [identity matrix](https://en.wikipedia.org/wiki/Identity_matrix)

For example, to store $M = 3$ vectors: $(+1, -1, -1, +1)$, $(−1, −1, +1, −1)$, $(+1, +1, +1, +1)$ to a network with $N = 4$ nodes:

$$ W = \begin{pmatrix}
        +1 \\
        -1 \\
        -1 \\
        +1 \\
        \end{pmatrix}
        \cdot
        \begin{pmatrix}
        +1 & -1 & -1 & +1
        \end{pmatrix}
        +
        \begin{pmatrix}
        -1 \\
        -1 \\
        +1 \\
        -1 \\
        \end{pmatrix}
        \cdot
        \begin{pmatrix}
        -1 & -1 & +1 & -1
        \end{pmatrix}
        +
        \begin{pmatrix}
        +1 \\
        +1 \\
        +1 \\
        +1 \\
        \end{pmatrix}
        \cdot
        \begin{pmatrix}
        +1 & +1 & +1 & +1
        \end{pmatrix} $$

Finally,

$$ W = \begin{pmatrix}
        0 & 1 & 1 & 3   \\
        1 & 0 & 1 & 1   \\
        -1 & 1 & 0 & -1 \\
        3 & 1 & -1 & 0  \\
        \end{pmatrix} $$

### Task
Implement a `hopfield/2` predicate:
- The first argument is a given list of vectors to be stored in a Hopfield Network. Every vector is also a list with the corresponding vector elements.
- The second argument will return the matrix containing the network weights, as a list of lists (one list per row).

### Execution Example
Input:

    ?- hopfield([
                    [+1,-1,-1,+1],
                    [-1,-1,+1,-1],
                    [+1,+1,+1,+1]
                ], W).


Output:

    W = [[0,1,-1,3], [1,0,1,1], [-1,1,0,-1], [3,1,-1,0]]

### Implementation
The `hopfield` predicate is implemented in `hopfield.pl`, along with several helper predicates.
