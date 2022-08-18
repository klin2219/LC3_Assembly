;;=============================================================
;;  CS 2110 - Summer 2022
;;  Homework 6 - Bubble Sort
;;=============================================================
;;  Name: Kevin Lin
;;============================================================

;;  In this file, you must implement the 'BUBBLE_SORT' subroutine.

;;  Little reminder from your friendly neighborhood 2110 TA staff: don't run
;;  this directly by pressing 'Run' in complx, since there is nothing put at
;;  address x3000. Instead, call the subroutine by doing the following steps:
;;      * 'Debug' -> 'Simulate Subroutine Call'
;;      * Call the subroutine at the 'BUBBLE_SORT' label
;;      * Add the [arr (addr), length] params separated by a comma (,) 
;;        (e.g. x4000, 5)
;;      * Proceed to run, step, add breakpoints, etc.
;;      * BUBBLE_SORT is an in-place algorithm, so if you go to the address
;;        of the array by going to 'View' -> 'Goto Address' -> 'Address of
;;        the Array', you should see the array (at x4000) successfully 
;;        sorted after running the program (e.g [2,3,1,1,6] -> [1,1,2,3,6])

;;  If you would like to setup a replay string (trace an autograder error),
;;  go to 'Test' -> 'Setup Replay String' -> paste the string (everything
;;  between the apostrophes (')) excluding the initial " b' ". If you are 
;;  using the Docker container, you may need to use the clipboard (found
;;  on the left panel) first to transfer your local copied string over.

.orig x3000
    ;; You do not need to write anything here
    HALT

;;  BUBBLE_SORT Pseudocode (see PDF for explanation and examples)
;; 
;;  BUBBLE_SORT(int[] arr (addr), int length) {
;;      int swapped = 0;
;;      for (int i = 0; i < length - 1; i++) {
;;          if (arr[i] > arr[i + 1]) {
;;              int temp = arr[i + 1];
;;              arr[i + 1] = arr[i];
;;              arr[i] = temp;
;;              swapped = 1;
;;          }
;;      }
;;      if (swapped == 1) {
;;          BUBBLE_SORT(arr, length - 1);
;;      }
;;      return;
;;  }

BUBBLE_SORT ;; Do not change this label! Treat this as like the name of the function in a function header
    ;; Code your implementation for the BUBBLE_SORT subroutine here!

    ; Build the stack
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

    AND R0, R0, #0 ; R0 = swapped = 0
    STR R0, R5, #0 ; LV1 = swapped = 0
    AND R1, R1, #0 ; R1 = i = 0

FOR
    LDR R2, R5, #5 ; R2 = length
    ADD R2, R2, #-1 ; R2 = length - 1
    NOT R2, R2 ; R2 = ~R2
    ADD R2, R2, #1 ; R2 = -R2
    ADD R2, R1, R2 ; R2 = i - (length - 1) < 0
    BRzp BREAK_FOR

    ;; For-loop condition is valid
    LDR R2, R5, #4 ; R2 = int[] arr (addr)
    AND R3, R3, #0 ; R3 = 0
    ADD R3, R2, R1 ; R3 = arr[i] (addr)
    LDR R3, R3, #0 ; R2 = arr[i] (value)
    AND R4, R4, #0 ; R4 = 0
    ADD R4, R2, R1 ; R4 = arr[i] (addr)
    ADD R4, R4, #1 ; R4 = arr[i + 1] (addr)
    LDR R4, R4, #0 ; R4 = arr[i + 1] (value)
    
    ;; Check if arr[i] > arr[i + 1]
    AND R0, R0, #0 ; R0 = 0
    ADD R0, R0, R4 ; R0 = R4 = arr[i + 1] (value)
    NOT R0, R0 ; R0 = ~R0
    ADD R0, R0, #1 ; R0 = -R0

    ADD R0, R3, R0 ; R0 = R3 + R0 = arr[i] - arr[i + 1] > 0
    BRp SWAP
    ADD R1, R1, #1 ; R1 = i + 1 = i++

BR FOR

SWAP
    AND R0, R0, #0 ; R0 = 0
    ADD R0, R0, R4 ; R0 = temp = arr[i + 1] (value)
    ADD R2, R2, R1 ; R2 = arr[i] (addr)
    ADD R2, R2, #1 ; R2 = arr[i + 1] (addr)
    STR R3, R2, #0 ; arr[i + 1] = arr[i]

    ADD R2, R2, #-1 ; R2 = arr[i] (addr)
    STR R0, R2, #0 ;; arr[i] = temp = arr[i + 1]

    AND R0, R0, #0 ;; R0 = swapped = 0
    ADD R0, R0, #1 ;; R0 = swapped = 1
    STR R0, R5, #0 ;; LV1 = swapped = 1
    ADD R1, R1, #1 ; R1 = i + 1
    BR FOR

BREAK_FOR
    LDR R4, R5, #0 ; R4 = swapped
    ADD R4, R4, #-1 ; R0 = swapped - 1 == 0
    BRnp TEARDOWN

    ADD R6, R6, -2 ;; Up the stack
    LDR R3, R5, #5 ;; R3 = length
    ADD R3, R3, #-1 ;; R3 = length - 1
    LDR R2, R5, #4 ;; R2 = arr (addr)
    STR R2, R6, #0 ;; Push arr
    STR R3, R6, #1 ;; Push length - 1
    JSR BUBBLE_SORT
    LDR R0, R6, #0
    ;; Push off the arguments
    ADD R6, R6, #3
    BR TEARDOWN

TEARDOWN
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

.orig x4000	;; Array : You can change these values for debugging!
    .fill 10
    .fill 9
    .fill 8
    .fill 7
    .fill 6
    .fill 5
    .fill 4
    .fill 3
.end