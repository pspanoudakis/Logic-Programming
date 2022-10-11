## Group A - Exercise 1
***

### Task
Implement a `diags(Matrix, DiagsDown, DiagsUp)` predicate:
- `Matrix` is a given 2-D matrix (a list of lists)
- `DiagsDown` will return a list of the descending diagonals of `Matrix`
- `DiagsUp` will return a list of the ascending diagonals of `Matrix`

### Execution Example
Input:

    ?- diags([[a,b,c,d],[e,f,g,h],[i,j,k,l]],DiagsDown,DiagsUp).

Output:

    DiagsDown = [[i],[e,j],[a,f,k],[b,g,l],[c,h],[d]]
    DiagsUp = [[a],[b,e],[c,f,i],[d,g,j],[h,k],[l]]

### Implementation
The `diags` predicate is implemented in `diags.pl`, along with several helper predicates.
