;;=============================================================
;;  CS 2110 - Summer 2022
;;  Homework 6 - Binary Search
;;=============================================================
;;  Name: Kevin Lin
;;============================================================

;;  In this file, you must implement the 'BINARY_SEARCH' subroutine.

;;  Little reminder from your friendly neighborhood 2110 TA staff: don't run
;;  this directly by pressing 'Run' in complx, since there is nothing put at
;;  address x3000. Instead, call the subroutine by doing the following steps:
;;      * 'Debug' -> 'Simulate Subroutine Call'
;;      * Call the subroutine at the 'BINARY_SEARCH' label
;;      * Add the [root (addr), data] params separated by a comma (,) 
;;        (e.g. x4000, 8)
;;      * Proceed to run, step, add breakpoints, etc.
;;      * Remember R6 should point at the return value after a subroutine
;;        returns. So if you run the program and then go to 
;;        'View' -> 'Goto Address' -> 'R6 Value', you should find your result
;;        from the subroutine there (e.g. Node 8 is found at x4008)

;;  If you would like to setup a replay string (trace an autograder error),
;;  go to 'Test' -> 'Setup Replay String' -> paste the string (everything
;;  between the apostrophes (')) excluding the initial " b' ". If you are 
;;  using the Docker container, you may need to use the clipboard (found
;;  on the left panel) first to transfer your local copied string over.

.orig x3000
    ;; You do not need to write anything here
    HALT

;;  BINARY_SEARCH Pseudocode (see PDF for explanation and examples)
;;  - Nodes are blocks of size 3 in memory:
;;      * The data is located in the 1st memory location (offset 0 from the node itself)
;;      * The node's left child address is located in the 2nd memory location (offset 1 from the node itself)
;;      * The node's right child address is located in the 3rd memory location (offset 2 from the node itself)

;;  BINARY_SEARCH(Node root (addr), int data) {
;;      if (root == 0) {
;;          return 0;
;;      }
;;      if (data == root.data) {
;;          return root;
;;      }
;;      if (data < root.data) {
;;          return BINARY_SEARCH(root.left, data);
;;      }
;;      return BINARY_SEARCH(root.right, data);
;;  }

BINARY_SEARCH ;; Do not change this label! Treat this as like the name of the function in a function header
    ;; Code your implementation for the BINARY_SEARCH subroutine here!
    ADD R6, R6, #-4 ; move up 4 for (RV, RA, FP, LV)
    STR R7, R6, #2 ; save RA
    STR R5, R6, #1 ;save old FP
    ADD R5, R6, #0 ; FP = SP
    ADD R6, R6, #-5 ; push 5 words
    STR R0, R6, #0 ; save SR1
    STR R1, R6, #1 ; save SR2
    STR R2, R6, #2 ; save SR3
    STR R3, R6, #3 ; save SR4
    STR R4, R6, #4 ; save SR5

    AND R2, R2, #0 ;; R2 = index = 0

    LDR R0, R5, #4 ;; R0 = root (addr)
    BRz ROOT_NULL

    LDR R1, R5, #5 ;; R1 = data
    LDR R0, R0, #0 ;; R0 = root.data
    NOT R0, R0 ;; R0 = ~R0
    ADD R0, R0, #1 ;; R0 = -R0 = -root.data
    ADD R0, R1, R0 ;; R0 = data - root.data == 0 
    BRz EQUAL_DATA

    ADD R3, R0, #0 ;; R2 = R0 = data - root.data < 0
    BRn SEARCH_LEFT

    AND R3, R3, #0 ;; R3 = 0
    ADD R3, R0, #0 ;; R3 = r0 = data - root.data > 0
    BR SEARCH_RIGHT
    
ROOT_NULL
    AND R2, R2, #0
    STR R2, R5, #3 ;; return 0
    BR TEARDOWN

EQUAL_DATA
    LDR R0, R5, #4 ;; R0 = root (addr)
    STR R0, R5, #3 ;; return root
    BR TEARDOWN

SEARCH_LEFT
    ADD R6, R6, #-2 ;; Move up the stack
    LDR R3, R5, #4 ;; R3 = root (addr)
    LDR R3, R3, #1 ;; R3 = root.left (addr)
    LDR R4, R5, #5 ;; R4 = data
    
    STR R3, R6, #0 ;; push root.left
    STR R4, R6, #1 ;; push data
    JSR BINARY_SEARCH

    LDR R0, R6, #0
    STR R0, R5, #3
    ADD R6, R6, #3 ;; push off arguments
    BR TEARDOWN

SEARCH_RIGHT
    ADD R6, R6, #-2 ;; Move up the stack
    LDR R3, R5, #4 ;; R2 = root (addr)
    LDR R3, R3, #2 ;; R3 = root.right (addr)
    LDR R4, R5, #5 ;; R4 = data

    STR R3, R6, #0 ;; push root.right
    STR R4, R6, #1 ;; push data
    JSR BINARY_SEARCH

    LDR R0, R6, #0
    STR R0, R5, #3
    ADD R6, R6, #3 ;; push off arguments
    BR TEARDOWN

TEARDOWN
    LDR R0, R6, #0 ; restore SR1
    LDR R1, R6, #1 ; restore SR2
    LDR R2, R6, #2 ; restore SR3
    LDR R3, R6, #3 ; restore SR4
    LDR R4, R6, #4 ; restore SR5
    ADD R6, R5, #0 ; pop saved regs and local vars
    LDR R7, R6, #2 ; R7 = ret addr
    LDR R5, R6, #1 ; FP = Old FP
    ADD R6, R6, #3 ; pop 2 words
    RET

;; Needed to Simulate Subroutine Call in Complx
STACK .fill xF000
.end

;;  Assuming the tree starts at address x4000, here's how the tree (see below and in the PDF) is represented in memory
;;
;;              4
;;            /   \
;;           2     8 
;;         /   \
;;        1     3 

.orig x4000 ;; 4    ;; node itself lives here at x4000
    .fill 4         ;; node.data (4)
    .fill x4004     ;; node.left lives at address x4004
    .fill x4008     ;; node.right lives at address x4008
.end

.orig x4004	;; 2    ;; node itself lives here at x4004
    .fill 2         ;; node.data (2)
    .fill x400C     ;; node.left lives at address x400C
    .fill x4010     ;; node.right lives at address x4010
.end

.orig x4008	;; 8    ;; node itself lives here at x4008
    .fill 8         ;; node.data (8)
    .fill 0         ;; node does not have a left child
    .fill 0         ;; node does not have a right child
.end

.orig x400C	;; 1    ;; node itself lives here at x400C
    .fill 1         ;; node.data (1)
    .fill 0         ;; node does not have a left child
    .fill 0         ;; node does not have a right child
.end

.orig x4010	;; 3    ;; node itself lives here at x4010
    .fill 3         ;; node.data (3)
    .fill 0         ;; node does not have a left child
    .fill 0         ;; node does not have a right child
.end

;;  Another way of looking at how this all looks like in memory
;;              4
;;            /   \
;;           2     8 
;;         /   \
;;        1     3 
;;  Memory Address           Data
;;  x4000                    4          (data)
;;  x4001                    x4004      (4.left's address)
;;  x4002                    x4008      (4.right's address)
;;  x4003                    Don't Know
;;  x4004                    2          (data)
;;  x4005                    x400C      (2.left's address)
;;  x4006                    x4010      (2.right's address)
;;  x4007                    Don't Know
;;  x4008                    8          (data)
;;  x4009                    0(NULL)
;;  x400A                    0(NULL)
;;  x400B                    Don't Know
;;  x400C                    1          (data)
;;  x400D                    0(NULL)
;;  x400E                    0(NULL)
;;  x400F                    Dont't Know
;;  x4010                    3          (data)
;;  x4011                    0(NULL)
;;  x4012                    0(NULL)
;;  x4013                    Don't Know
;;  
;;  *Note: 0 is equivalent to NULL in assembly