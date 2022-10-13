## Group A - Exercise 3

### Context
In an amusement park, there is a number of arcade games. which can be played in a **pre-fixed** order.
Each game can be played **1+** times (at least once), which must be **consecutive**.

To play a game each time, a mark is required. To store your marks, you use a box, with a capacity of $T$ marks, which is initially **full**.
After you decide to play another game, you are given **up to** $K$ marks, but your box capacity cannot be exceeded.

Each time you play the game $i$, your **pleasure** is increased by $P_i$, which can be positive, negative or $0$.

### Task
Given $T$, $K$ and $P_i$ for each game, you need to decide how many times each game must be played (given the above constraints), in order to **maximize** you total pleasure.
Implement a `games(Ps,T,K,Gs,P)` predicate:
- `Ps` is the list of $P_i$ pleasure values.
- `T` is the box capacity.
- `K` is the maximum mark bonus before switching to a new game.
- `Gs` will return the number of times each game must be played.
- `P` is the maximum pleasure.

### Execution Example
Input:

    ?- games([4,1,-2,3,4],3,2,Gs,P).

Output:

    Gs = [3,2,1,2,3]
    P = 30 --> ;
    no

### Implementation
The `games` predicate is implemented in `games.pl`, along with several helper predicates.

This is a typical Constraint Satisfaction Problem, but the use of CSP libraries was not allowed in Group A exercises. On the other hand, Group B exercises are all CSP-based and take advantage of such libraries.

[Exercise 2 in Group B](../GamesPleasureCSP) is identical, but uses the `ic` and `branch_and_bound` libraries.
