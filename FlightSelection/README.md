## Group B - Exercise 3

### Context
An Airline has to schedule $N$ flights during a predefined time period.\
Each flight can be referenced using an id $(1, 2, 3 ... N)$.

The airline has pre-generated $M$ flight combinations (pairings).\
Each pairing $P_i$ (where $ 1 \le i \le M$), may include a subset of the flights $1, 2, 3 ... N$. It is **feasible**, and is assigned to a **specific captain**.

The task is to select a subset of the available pairings, so that
each flight is assigned to **exactly 1 captain**.

A $P_i$ pairing has a cost of $C_i$. The **sum of costs** of the selected pairings, is the **total cost** for the selection.

### Task
You will use [get_flight_data(I, N, P, C)](./flight_data.pl) to get pre-generated pairings.
- `I` is an index number, from **1 to 16**.
- `N` returns the number of flights.
- `P` returns the pairings (list of lists).
- `C` returns a list with the pairing costs.

Implement a `flights(I, Pairings, Cost)` predicate:
- `I` is the index number to be provided to `get_flight_data`.
- `Pairings` returns the optimal pairings selection.
- `Cost` returns the total cost of the selection.

### Execution Example
Input:

    ?-  member(I, [1, 2, 3, 4]),
        write('I = '), writeln(I),
        flights(I, Pairings,Cost),
        write('Pairings = '), writeln(Pairings),
        write('Cost = '), writeln(Cost), nl, fail.


Output:

    I = 1
    Pairings = [[1, 2, 3, 7] / 10,
                [5, 8] / 12,
                [4, 9, 10] / 34,
                [6] / 34]
    Cost = 90

    I = 2
    Pairings = [[1, 2, 5, 8] / 10,
                [3, 6, 9] / 25,
                [4, 7, 10] / 20]
    Cost = 55

    I = 3
    Pairings = [[6, 9] / 32,
                [2, 5, 8] / 10,
                [1, 3, 4, 7, 10] / 28]
    Cost = 70

    I = 4
    Pairings = [[1, 5, 11] / 2,
                [7, 10, 12] / 3,
                [2, 9, 15, 16] / 1,
                [4, 8, 14] / 2,
                [3, 6, 13] / 1]
    Cost = 9

### Implementation
- The `flights` predicate is implemented in `flights.pl`, along with several helper predicates.
- The `get_flight_data` predicate was pre-implemented in `flight_data.pl`.
- The `acsdata` directory contains data used by `get_flight_data`, for indexes from 7 up to 16.
