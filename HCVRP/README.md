## Group B - Exercise 4

### Context
In this exercise, we examine the *Heterogenous Capacitated Vehicle Routing Problem* (HCVRP).

A company is about to deliver specific quantities of its product to its clients. Initially, the product in its totality is stored in the company storage.

To deliver the product, the company uses a number of vehicles, possibly of different capacities.

Below we can see the data for an instance of this problem, for 8 vehicles and 20 clients:

    vehicles([35, 40, 55, 15, 45, 25, 85, 55]).

    clients([c(15, 77, 97), c(23, -28, 64), c(14, 77, -39),
    c(13, 32, 33), c(18, 32, 8), c(18, -42, 92),
    c(19, -8, -3), c(10, 7, 14), c(18, 82, -17),
    c(20, -48, -13), c(15, 53, 82), c(19, 39, -27),
    c(17, -48, -13), c(12, 53, 82), c(11, 39, -27),
    c(15, -48, -13), c(25, 53, 82), c(14, -39, 7),
    c(22, 17, 8), c(23, -38, -7)]).

This data are defined in [`hcvrp_data.pl`](./hcvrp_data.pl).

- The list defined in `vehicles/1` represents the capacities of the company's vehicles.
- The list defined in `clients/1` contains `c(D, X, Y)` tuples, one for each client:
    - `D` is the quantity ordered by this client.
    - `X` & `Y` are the client coordinates.

The task is to optimally deliver the ordered produt quantity to each client:
- Each vehicle **starts from the storage**, having loaded the total quantity ordered by the clients it is about to serve, which **cannot exceed its total capacity**.\
After the end of the route, the vehicle **returns to the storage**.
- The storage coordinates are (0, 0). The clients are connected with each other (and with the storage), with **straight line roads**. Therefore, the distance between two clients or between a client and the storage, is their **[Euclidean Distance](https://en.wikipedia.org/wiki/Euclidean_distance)**.
- The **Cost** of a route is the **total distance travelled by the vehicles**.
To pretty-print the cost of a route, we mutliply it by 1000 and round it up/down to the nearest integer.

### Task
Implement an `hcvrp(NCl, NVe, Timeout, Solution, Cost, Time)` predicate:
- The first `NCl` clients from the predefined data will be used.
- The first `NVe` vehicles from the predefined data will be used.
- `Timeout` is a time limit (in secs) to stop the execution and return the best solution found up to that point.
- `Solution` is the best found solutiom, a list of lists. Each list represents the route of the corresponding vehicle: It contains the index numbers of the clients that will be served by this vehicle, in the order they will be served. Of course a vehicle may have no route, in which case its list will be empty.
- `Cost` is the total cost of the solution, calculated as described above.
- `Time` is the total CPU time elapsed.

### Execution Examples
-   Input:

        ?- hcvrp(1, 1, 0, Solution, Cost, Time).

    Output:

        Found a solution with cost 247694
        Solution = [[1]]
        Cost = 247694
        Time = 0.0
***
-   Input:

        ?- hcvrp(2, 1, 0, Solution, Cost, Time).

    Output:

        Found no solution with cost 0.0 .. 371541.0
***
-   Input:

        ?- hcvrp(2, 2, 0, Solution, Cost, Time).

    Output:

        Found a solution with cost 303768
        Found no solution with cost 0.0 .. 303767.0
        Solution = [[], [2, 1]]
        Cost = 303768
        Time = 0.0
***
-   Input:        

        ?- hcvrp(3, 2, 0, Solution, Cost, Time).

    Output:

        Found a solution with cost 485874
        Found a solution with cost 476394
        Found no solution with cost 0.0 .. 476393.0
        Solution = [[3], [2, 1]]
        Cost = 476394
        Time = 0.0
***
-   Input:

        ?- hcvrp(4, 2, 0, Solution, Cost, Time).

    Output:

        Found a solution with cost 529519
        Found a solution with cost 520954
        Found no solution with cost 0.0 .. 520953.0
        Solution = [[4, 3], [2, 1]]
        Cost = 520954
        Time = 0.0
***
-   Input:

        ?- hcvrp(5, 2, 0, Solution, Cost, Time).

    Output:

        Found no solution with cost 0.0 .. 1718544.0
***
-   Input:

        ?- hcvrp(5, 3, 0, Solution, Cost, Time).

    Output:

        Found a solution with cost 606884
        Found a solution with cost 572409
        Found a solution with cost 569259
        Found a solution with cost 552201
        Found a solution with cost 541537
        Found a solution with cost 526117
        Found a solution with cost 523843
        Found a solution with cost 506186
        Found a solution with cost 488492
        Found no solution with cost 0.0 .. 488491.0
        Solution = [[], [5, 3], [4, 1, 2]]
        Cost = 488492
        Time = 0.04
***
-   Input:

        ?- hcvrp(8, 4, 0, Solution, Cost, Time).

    Output:

        Found a solution with cost 859115
        Found a solution with cost 836986
        Found a solution with cost 828848
        Found a solution with cost 821892
        Found a solution with cost 806634
        Found a solution with cost 804930
        Found a solution with cost 726824
        Found a solution with cost 712619
        Found a solution with cost 702248
        Found no solution with cost 0.0 .. 702247.0
        Solution = [[3, 1], [7, 5], [4, 6, 2], [8]]
        Cost = 702248
        Time = 1.99

<small>
The costs of the intermediate solutions, as well as the final solution routes may differ, but the cost of the final solution must be the same.
</small>

### Implementation
- The `hcvrp` predicate is implemented in `hcvrp.pl`, along with several helper predicates.
- The `clients/1` and `vehicles/1` predicates were pre-defined in `hcvrp_data.pl`.
