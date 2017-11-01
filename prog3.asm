TITLE Program Template     (template.asm)

; Author: Reuben Youngblom
; Course / Project ID: CS271, project 3                 Date: October 29th 2017
; Description: Project 3. takes in negative integers and returns average, sum, and number of integers.

INCLUDE Irvine32.inc

; (insert constant definitions here)
lower_limit = -100		;lower limit of acceptable numbers, defined as a constant


.data

addSumX	SWORD	?				;accumulator variable to hold sum total
holder	SWORD	?				;holder variable for when I need to swap intergers
loopThrough	WORD	?			;tracker variable for counting loops
addAverage	SWORD	?			;tracks the sum of the numbers for average purposes
totalAverage	SWORD	?		;holds the current average every loop
currentInt	SWORD	?			;track the current integer (for swapping)
intro	BYTE	"Program 2; Reuben Youngblom", 0		;intro statement
prompt	BYTE	"What is your name? ", 0				;user prompt
thanks	BYTE	"Thanks, ", 0							; thanks statement
user_name	BYTE	33 DUP(0)							;holds user name
keepCount	DWORD	?									;counter variable
int_dir	BYTE	"Please enter numbers in [-100, -1].", 0			;user prompt
aux_dir	BYTE	"Enter a non-negative number when you are finished to see results.", 0	;user prompt
num_dir	BYTE	". Please enter a number:", 0						;user prompt
tooLow	BYTE	"Number too low, please try again!", 0				;error message if number is too low
avgByte	SBYTE	-7									;extra, was planning to use it for average but didn't.
youEntered	BYTE	"You entered ", 0						; user prompt
validInt	BYTE	" valid integers!", 0					; user prompt
sumIs	BYTE	"The sum of your valid integers is: ", 0	;gives user the sum
avIs	BYTE	"The rounded average is: ", 0				;user information
outThanks	BYTE	"Thank you for playing Integer Accumulator! It's been a pleasure to meet you, ", 0			; Outro
specialMsg	BYTE	"You didn't enter any numbers! Thank you for playing Integer Accumulator! It's been a pleasure to meet you, ", 0	;special no-entry message
ExtraC	BYTE	"**EC: Line numbers (only valid input)", 0				;extra credit formatting


; (insert variable definitions here)

.code
main PROC

;I was having some register issues with my program, so here, I just clear and reset everything
MOV	addSumX, 0
MOV	loopThrough, 0
MOV	addAverage, 0
MOV	totalAverage, 0
MOV	keepCount, 1
MOV	EAX,0


; (insert executable instructions here)

	;extra credit print statement
	mov	edx, OFFSET extraC			;prints EC in proper format
	call	writeString
	call	CrLf
	call	CrLf					;for aesthetics


	;introduction:  direction for user
	mov	edx, OFFSET intro			;gives the intro
	call	writeString
	call	CrLf					;for aesthetics
	call	CrLf


	;User Instruction: asks for name, gets name, etc

	mov	edx, OFFSET prompt		;prompt for name
	call	writestring

	mov	edx, OFFSET user_name	;reads user name
	mov	ecx, 32					;up to 32 characters
	call	readString			;and actually reads it

	call	CRLF				;for aesthetics

	mov	edx, OFFSET thanks			;thanks message
	call	writeString				;prints it


	mov	edx, OFFSET user_name		;prints name (same line as above)
	call	writestring				;actaully prints it
	call CrLf						;return
	call	CrLf

	mov	edx, OFFSET int_dir			;user prompt
	call	Writestring				;prints it
	call	CrLf

	mov	edx, OFFSET aux_dir			;user prompt
	call	Writestring				;prints it
	call	CrLf
	call	CrLf					;the CrLfs are all for aesthetics
	

	;program: main loop.  Keeps looping here until postive number is entered

Signed:
	mov	eax,keepCount				;loop tracker for line numbers	
	call	writeDec				;writes it out
	mov	edx, OFFSET num_dir			;user prompt
	call	Writestring				;prints it
	call	readInt					;get integer input, either positive or negative
	JNS	Unsigned					;if not signed (positive), jump to "unsigned" section
	JS	SignedAux					;if signed (negative), move on to SignedAux section


	;validation:  This section validates user input
lowBound:								;for if initial number is too low
	mov	edx, OFFSET tooLow				;calls tooLow
	call	writeString					;prints message
	call	crlf						;new line
	jmp	Signed							;jumps back to Signer
	
	;auxiliary loop:  does all the calculations for if number is negative
SignedAux:
	MOV	currentInt, AX
	cmp	currentInt, lower_limit		;checks against lower limit
	jl	lowBound					;if it's under, jumps to lowBound
	inc	loopThrough					;increases loop counter
	inc	keepCount					;increases number line counter
	MOV	AX,currentInt				;stores currentInt in AX
	ADD	addSumX, AX					;adds currentInt to addSum (accumulator)
	MOV	currentInt, AX				;moves AX back into currentInt
	MOV	AX, addSumX					;and stores addSum back into AX
	;call	writeInt				;these were for testing, commented out
	;call	CrLf					;same: for testing, but useful to comment out instead of delete
	MOV	holder, AX					;stores AX in holder variable
	MOV	AX, holder					;and makes sure they're equal
	JMP	Average						;and moves on to Average section

	;Average Loop:  Calcuates the rounded average
Average:						;gets average of all numbers
	MOV	AX,addSumX				;puts addSum in AX
	MOV	addAverage, AX			;and in addAverage
	MOV	dx,0					;clears DX
	MOV	AX, addAverage			;I wanted to make double sure that AX and addAverage were the same
	CWD							;convert word to doubleword
	MOV	BX, loopThrough			;moves loopCounter to BX
	IDIV	BX					;divides AX (addAverage) by BX (loops through)
	MOV	totalAverage, AX		;moves result to totalAverage
	MOV	AX, addAverage			;moves addAverage back to AX
	JMP	Signed					;and loops again

	;unsigned loop:  jumps here when positive integer is entered.  Basically prints out results
Unsigned:
	MOV	AX, loopThrough			;puts loop counter in AX
	CMP	AX,0					;compares to zero (no negative numbers have been entered).  If zero...
	JE	Special					;jumps to special message

	mov	edx, OFFSET youEntered	;gives the first part of outro
	call	writeString			;prints it
	MOV	AX, loopThrough			;moves loop counter
	call	writeDec			;prints it
	mov	edx, OFFSET validInt	;gives the last half of outro
	call	writeString
	call	CrLf				;return
	
	mov	edx, OFFSET avIs	;gives the sum prompt
	call	writeString		;writes it
	MOV	EAX,-1				;clears the EAX reg. sets all to ffffffff
	MOV	AX,0				;sets ax to 0000, eax to ffff0000
	MOV	AX, totalAverage	;moves totalAverage to ax
	call	writeInt		;prints it
	call	CrLf			;return

	mov	edx, OFFSET sumIs	;gives the sum prompt
	call	writeString		;writes it
	MOV	EAX,-1				;clears the EAX reg. sets all to ffffffff
	MOV	AX,0				;sets ax to 0000, eax to ffff0000
	MOV	AX, addSumX			;moves sumX to ax reg
	call	writeInt		;writes it
	call	CRLF			;return

	mov	edx, OFFSET outThanks	;gives the final prompt
	call	writeString
	mov	edx, OFFSET user_name	;prints name (same line as above)
	call	writestring			;actaully prints it
	call CrLf					;return

	JMP Close	;jumps to program end


;program end: special statements and close
	
Special:
	mov	edx, OFFSET specialMsg	;gives the special prompt
	call	writeString
	mov	edx, OFFSET user_name	;prints name (same line as above)
	call	writestring			;actaully prints it
	call CrLf					;return

Close:
	call	CrLf		;ends the program 


	exit				; exit to operating system
main ENDP

; (insert additional procedures here)

END main


