## Logic Programming using Prolog
This is a series of exercises for the Spring 2021 [Logic Programming](https://cgi.di.uoa.gr/~takis/ys05.html) course in [DIT@UoA](https://www.di.uoa.gr/en).

All exercises are implemented in [ECLiPSe-CLP](https://eclipseclp.org/) Prolog.

### Group A
The exercises of this group are implemented using the standard ECLiPSe-CLP Prolog predicates.

1. [`MatrixDiagonals`](./MatrixDiagonals/): Finding the ascending & descending diagonals of a 2-D Matrix.
2. [`HopfieldNetworkTraining`](./HopfieldNetworkTraining/): Computing the edge weights of a Hopfield Network.
3. [`GamesPleasure`](./GamesPleasure/): Solving a maximization CSP, solved using standard predicates.

### Group B
The exercises of this group are all CSP-based problems, and are solved using the [`ic`](https://eclipseclp.org/doc/bips/lib/ic/index.html), [`ic_global`](https://eclipseclp.org/doc/bips/lib/ic_global/index.html) and [`branch_and_bound`](https://eclipseclp.org/doc/bips/lib/branch_and_bound/index.html) libraries provided by ECLiPSe-CLP.

1. [`ImageDecode`](./ImageDecode/): Decoding and printing an encoded black and white image, using the constraints regarding the number of black pixels in each row, column and diagonal.
2. [`GamesPleasureCSP`](./GamesPleasureCSP/): Solving the Exercise 3 of Group A, this time using the `ic` and `branch_and_bound` libraries.
3. [`FlightSelection`](./FlightSelection/): Finding the optimal flight schedule for an airline.
4. [`HCVRP`](./HCVRP/): Solving instances of the *Heterogenous Capacitated Vehicle Routing Problem*.
