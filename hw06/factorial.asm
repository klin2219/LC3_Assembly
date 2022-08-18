;;=============================================================
;;  CS 2110 - Summer 2022
;;  Homework 6 - Factorial
;;=============================================================
;;  Name: Kevin Lin
;;============================================================

;;  In this file, you must implement the 'MULTIPLY' and 'FACTORIAL' subroutines.

;;  Little reminder from your friendly neighborhood 2110 TA staff: don't run
;;  this directly by pressing 'Run' in complx, since there is nothing put at
;;  address x3000. Instead, call the subroutine by doing the following steps:
;;      * 'Debug' -> 'Simulate Subroutine Call'
;;      * Call the subroutine at the 'MULTIPLY' or 'FACTORIAL' labels
;;      * Add the [a, b] or [n] params separated by a comma (,) 
;;        (e.g. 3, 5 for 'MULTIPLY' or 6 for 'FACTORIAL')
;;      * Proceed to run, step, add breakpoints, etc.
;;      * Remember R6 should point at the return value after a subroutine
;;        returns. So if you run the program and then go to 
;;        'View' -> 'Goto Address' -> 'R6 Value', you should find your result
;;        from the subroutine there (e.g. 3 * 5 = 15 or 6! = 720)

;;  If you would like to setup a replay string (trace an autograder error),
;;  go to 'Test' -> 'Setup Replay String' -> paste the string (everything
;;  between the apostrophes (')) excluding the initial " b' ". If you are 
;;  using the Docker container, you may need to use the clipboard (found
;;  on the left panel) first to transfer your local copied string over.

.orig x3000
    ;; You do not need to write anything here
    HALT

;;  MULTIPLY Pseudocode (see PDF for explanation and examples)   
;;  
;;  MULTIPLY(int a, int b) {
;;      int ret = 0;
;;      while (b > 0) {
;;          ret += a;
;;          b--;
;;      }
;;      return ret;
;;  }

MULTIPLY ;; Do not change this label! Treat this as like the name of the function in a function header
    ;; Code your implementation for the MULTIPLY subroutine here!
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

    ;; Work on mult()
    AND R0, R0, #0 ;R0 = ret = 0
    LDR R1, R5, #5 ;R0 = b
    ; while (b > 0)
    WHILE
    BRnz TEARDOWN1
        LDR R2, R5, #4 ; R2 = a
        ADD R0, R0, R2 ; R0 = ret + a
        ADD R1, R1, #-1 ;; b--
    BR WHILE

; return ret;
TEARDOWN1
    STR R0, R5, #3 ;set return value to ret
    LDR R0, R6, #0 ; restore SR1
    LDR R1, R6, #1 ; restore SR2
    LDR R2, R6, #2 ; restore SR3
    LDR R3, R6, #3 ; restore SR4
    LDR R4, R6, #4 ; restore SR5
    ADD R6, R5, #0 ; pop saved regs and local vars
    LDR R7, R6, #2 ; R7 = ret addr
    LDR R5, R6, #1 ; FP = Old FP
    ADD R6, R6, #3 ; pop 3 words
    RET ; mult() is done
;; MULTIPLY(1, 3) should return 3

;;  FACTORIAL Pseudocode (see PDF for explanation and examples)
;;
;;  FACTORIAL(int n) {
;;      int ret = 1;
;;      for (int x = 2; x <= n; x++) {
;;          ret = MULTIPLY(ret, x);
;;      }
;;      return ret;
;;  }

;; FACTORIAL(3) = 6, FACTORIAL(4) = 24

FACTORIAL ;; Do not change this label! Treat this as like the name of the function in a function header
    ;; Code your implementation for the FACTORIAL subroutine here!'
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

    AND R0, R0, #0 ; R0 = ret = 0
    ADD R0, R0, #1 ; R0 = ret = 1

    AND R1, R1, #0 ; R1 = x = 0
    ADD R1, R1, #2 ; R2 = x = 2

FOR 
    LDR R2, R5, #4 ; R2 = n
    NOT R2, R2 ; R2 = ~R2
    ADD R2, R2, #1 ; R2 = -R2
    ADD R2, R1, R2 ; R2 = x - n <= 0
    BRp TEARDOWN0
    
    ADD R6, R6, #-2 ;; Up the stack
    STR R0, R6, #0  
    STR R1, R6, #1
    JSR MULTIPLY
    LDR R0, R6, #0

    ;; Push off arguments
    ADD R6, R6, #3
    ADD R1, R1, #1
BR FOR
    
TEARDOWN0
    STR R0, R5, #3 ;set return value to ret
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