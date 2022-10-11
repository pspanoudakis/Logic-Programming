## Group B - Exercise 2

### Context - Task
This exercise is identical to [Exercise 3 of Group A](../GamesPleasure/).

This time, the goal is to use libraries designed for solving CSP's, like `ic` and `branch_and_bound`, 
to implement a `games_csp/5` predicate, which operates just as `games/5`.

### Execution Example
Input:

    ?- games_csp([1,2,3,4,5,6,5,4,3,2,1],10,8,Gs,P).

Output:

    Gs = [8, 8, 8, 8, 8, 10, 8, 8, 8, 8, 8]
    P = 300 --> ;
    no

### Implementation
The `games_csp` predicate is implemented in `games_csp.pl`, along with several helper predicates.
