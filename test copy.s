  .syntax unified
  .cpu cortex-m3
  .fpu softvfp
  .thumb

  .global  Init_Test
  .global  Main
  .global  testGrid
  .global  string

@
@ Main
@
@ An implementation of Main to test each of our subroutines
@ You should "comment out" all but one subroutine call
@   to test individual subroutines as you develop them.
@
@ Modify the tests to suit your needs.
@
Main:
  PUSH {LR}
End_Main:
  LDR R0, =testGrid
  LDR R1, =testString
  POP   {PC}


  .section  .data.test
@ Sudoku Test Grid
testGrid:
  .byte 'a','f','l','l'
  .byte 'h','e','l','l'
  .byte 'k','a','r','s'
  .byte 'v','a','l','t'


@
@ Subroutine to initialise test inputs
@
  .section  .text
  .type     Init_Test, %function
Init_Test:
  STMFD   SP!, {LR}
  BL      InitRam           @ Copy initial RAM contents from ROM
  LDR     R1, =testString   @ Set R1 to start address of test string (in RAM)
  LDMFD   SP!, {PC}



@
@ Initial test data for RAM
@ This initial data will be copied from ROM to
@   to RAM before your program starts.
@
  .section  .rodata
init_start:

@ Initial contents of test string
init_testString:
  .asciz  "hell"    @ modify to change the initial test string
.equ   size_testString, .-init_testString

init_end:


  .section  .data
data_start:
testString:
  .space  size_testString   @ reserve enough space in RAM for the test string



@ InitRam subroutine
@ Utility subroutine to initialise RAM from ROM
  .section  .text
  .type     Init_Test, %function
InitRam:

  STMFD   SP!, {R4-R7,LR}
  
  LDR   R4, =init_start    @ start address of initialisation data
  LDR   R5, =init_end      @ end address of initialisation data
  LDR   R6, =data_start    @ start oddress of RAM data

.LwhInit:
  CMP   R4, R5            @ copy word-by-word from init_start
  BHS   .LewhInit         @   to init_end in ROM, storing in RAM
  LDR   R7, [R4], #4      @   starting at data_start
  STR   R7, [R6], #4      @
  B     .LwhInit          @
.LewhInit:                @

  LDMFD   SP!, {R4-R7,PC}

.end