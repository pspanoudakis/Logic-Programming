## Group B - Exercise 1

### Task
A **2-dimensional, black and white image**,  has been scanned horizontally, vertically and diagonally (both ascending & descending).\
It has been **encoded** based on the **number of black pixels** in **each row**, **each column** and **each ascending & desceding diagonal**.

Implement a `decode/4` predicate:
- The first argument is a list with the number of black pixels in each row.
- The second argument is a list with the number of black pixels in each column.
- The third argument is a list with the number of black pixels in each ascending diagonal.
- The fourth argument is a list with the number of black pixels in each desceding diagonal.

The predicate should decode the image and print it.\
You may use the `diags/3` predicate implemented in [Exercise 1 of Group A](../MatrixDiagonals).


### Execution Example
Input:

    ?- decode(
            [4,4,3,3,4,4],
            [2,2,2,4,2,4,2,2,2],
            [0,2,1,0,2,1,5,5,1,2,0,1,2,0],
            [0,2,1,0,2,1,5,5,1,2,0,1,2,0]
        ).

Output:

    . * * . . . * * .
    * . . * . * . . *
    . . . * * * . . .
    . . . * * * . . .
    * . . * . * . . *
    . * * . . . * * .

### Implementation
The `decode` predicate is implemented in `decode.pl`, along with several helper predicates.\
The `diags\3` predicate, implemented [here](../MatrixDiagonals/diags.pl) is also used.
