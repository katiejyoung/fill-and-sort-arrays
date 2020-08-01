## Objectives:
1. using register indirect addressing
2. passing parameters
3. generating “random” numbers
4. working with arrays
##Description:
Write and test a MASM program to perform the following tasks:
1. Introduce the program.
2. Get a user request in the range [min = 10 .. max = 200].
3. Generate request random integers in the range [lo = 100 .. hi = 999], storing them in consecutive elements
of an array.
4. Display the list of integers before sorting, 10 numbers per line.
5. Sort the list in descending order (i.e., largest first).
6. Calculate and display the median value, rounded to the nearest integer.
7. Display the sorted list, 10 numbers per line.
## Requirements:
1. The title, programmer's name, and brief instructions must be displayed on the screen.
2. The program must validate the user’s request.
3. min, max, lo, and hi must be declared and used as global constants.
4. Strings must be passed by reference.
5. The program must be constructed using procedures. At least the following procedures are required:
   * main
   * introduction
   * get data {parameters: request (reference)}
   * fill array {parameters: request (value), array (reference)}
   * sort list {parameters: array (reference), request (value)}
      * exchange elements (for most sorting algorithms): {parameters: array[i] (reference),
array[j] (reference), where i and j are the indexes of elements to be exchanged}
   * display median {parameters: array (reference), request (value)}
   * display list {parameters: array (reference), request (value), title (reference)}
6. Parameters must be passed by value or by reference on the system stack as noted above.
7. There must be just one procedure to display the list. This procedure must be called twice: once to display
the unsorted list, and once to display the sorted list.
8. Procedures (except main) should not reference .data segment variables by name. request, array, and titles
for the sorted/unsorted lists should be declared in the .data segment, but procedures must use them as
parameters. Procedures may use local variables when appropriate. Global constants are OK.
9. The program must use register indirect addressing for array elements.
10. The two lists must be identified when they are displayed (use the title parameter for the display
procedure).
11. The program must be fully documented. This includes a complete header block for the program and for
each procedure, and a comment outline to explain each section of code.
12. The code and the output must be well-formatted.
13. Submit your text code file (.asm) to Canvas by the due date. 
