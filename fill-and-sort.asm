TITLE Program 5

; Author: Katelyn Young
; Email: youngkat@oregonstate.edu
; CS 271-400
; Project ID: Assignment 5		Date: 5/26/19
; Description: Use register indirect addressing, pass parameters, generate "random" numbers and
; ---work with arrays

INCLUDE Irvine32.inc

.386
.model flat,stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword

MIN EQU 10
MAX EQU 200
LO EQU 100
HI EQU 999

introduction proto arg1:ptr, arg2:ptr, arg3:ptr, arg4:ptr, arg5:ptr
getUserData proto, arg1:ptr, arg2:ptr
fillArray proto, array:ptr, userCount:DWORD, rand:DWORD, idx:DWORD
sortList proto, array:ptr, userCount:DWORD
displayMedian proto, array:ptr, userCount:DWORD, titleString:ptr
displayList proto, array:ptr, userCount:DWORD, titleString:ptr, spaceString:ptr, outputCount:DWORD
farewell proto, endString:ptr

.data
; Introduction strings
introProgramTitle BYTE	"Program 5, MASM Advanced Procedures", 0
introProgrammer BYTE	"Programmer: Katie Young", 0
introInstructions1 BYTE "This program generates random numbers in the range [100-999], ", 0
introInstructions2 BYTE "displays the original list, sorts the list, and calculates the ", 0
introInstructions3 BYTE "median value. Finally, it displays the list sorted in descending order.", 0

; Gather and validate user input strings
promptUserInput BYTE "How many numbers should be generated? [10-200]: ", 0
invalidInputMsg BYTE "The provided input is invalid.", 0

; Output message strings
outputUnsorted BYTE "The unsorted random numbers:", 0
outputMedian BYTE "The median is: ", 0
outputSorted BYTE "The sorted list:", 0

spaceOutput BYTE "   ", 0
exitGreeting BYTE "Goodbye.", 0

numArray DWORD (MAX + 1) DUP(?) ; array of integers

userInt DWORD ?			; signed integer provided by user
randInt DWORD ?			; randomly-generated integer
index DWORD 0			; index placeholder for random number generation
output DWORD ?			; counter to reset ecx

.code
main proc
	; Intruduce programmer
	invoke	introduction, OFFSET introProgramTitle, OFFSET introProgrammer, OFFSET introInstructions1, OFFSET introInstructions2, OFFSET introInstructions3
	
	; Gather and validate user input
	invoke	getUserData, OFFSET promptUserInput, OFFSET invalidInputMsg
	mov userInt, eax

	; Fill array with random integers and output
	invoke fillArray, OFFSET numArray, userInt, randInt, index
	invoke displayList, OFFSET numArray, userInt, OFFSET outputUnsorted, OFFSET spaceOutput, output

	; Sort list
	invoke sortList, OFFSET numArray, userInt

	; Calculate and display median
	invoke displayMedian, OFFSET numArray, userInt, OFFSET outputMedian

	; Display sorted list
	invoke displayList, OFFSET numArray, userInt, OFFSET outputSorted, OFFSET spaceOutput, output

	; Output closing string and end program
	invoke	farewell, OFFSET exitGreeting

	invoke ExitProcess,0

	; Exit to operating system
	exit	
main endp


introduction proc arg1:ptr, arg2:ptr, arg3:ptr, arg4:ptr, arg5:ptr
; Receives: Programmer name and program title
; Returns: No value returned
; ----------------------------------------------------------------------------------------------------------
	mov		edx, arg1
	call	WriteString
	call	CrLf

	mov		edx, arg2
	call	WriteString
	call	CrLf
	call	CrLf

	mov		edx, arg3
	call	WriteString
	call	CrLf

	mov		edx, arg4
	call	WriteString
	call	CrLf

	mov		edx, arg5
	call	WriteString
	call	CrLf

	call	CrLf

	ret
introduction endp

getUserData proc, arg1:ptr, arg2:ptr
; Receives: Instruction strings and user-input variable
; Returns: EAX = validated integer
; ----------------------------------------------------------------------------------------------------------
	UL:
		; Output instructions
		mov		edx, arg1
		call	WriteString
		call	CrLf

		; Read user input
		call	ReadInt

		; Validate input
		cmp		eax, MAX
		jg		invalid
		cmp		eax, MIN
		jl		invalid

		loop	return

	invalid:
		mov		edx, arg2
		call	WriteString
		call	CrLf
		loop	UL
	
	return:
		ret
getUserData endp

fillArray proc, array:ptr, userCount:DWORD, rand:DWORD, idx:DWORD
; Receives: array, user-provided loop counter, two variables for data storage
; Returns: Filled array
; ----------------------------------------------------------------------------------------------------------
	mov		ecx, userCount 
	mov		esi, array

	generateNumber:
		; Generate random number
		mov		eax, HI
		sub		eax, LO
		inc		eax
		call	RandomRange
		add		eax, LO

		mov		ebx, idx

		; Add random number to array and increase ecx
		mov		[esi + (ebx * 4)], eax
		inc		ebx
		mov		eax, 0
		mov		idx, ebx

		; Loop until stopping condition met
		cmp		ebx, userCount
		je		ender
		loop	generateNumber
		
	ender:
		ret
				
fillArray endp

sortList proc, array:ptr, userCount:DWORD
; Receives: array, user-provided loop counter
; Returns: sorted array
; ----------------------------------------------------------------------------------------------------------
; Set ecx counter
mov		ecx, userCount

L1:
	; Push ecx to stack and move array address to esi
	push	ecx
	mov		esi, array

L2:
	; Swap values if necessary
	mov		eax, [esi]
	cmp		eax, [esi + 4]
	jg		L3
	xchg	eax, [esi + 4]
	mov		[esi], eax

L3:
	; Increment iteration
	add		esi, 4
	loop	L2
	pop		ecx
	loop	L1

L4:
	ret
sortList endp

displayMedian proc, array:ptr, userCount:DWORD, titleString:ptr
; Receives: Array reference, user-provided input, reference to string label
; Returns: Printed representation of median
; ----------------------------------------------------------------------------------------------------------
; Move array address to esi
mov		esi, array

; Establish even/odd array length and calculate appropriately
mov		eax, userCount
xor		edx, edx
mov		ebx, 2
div		ebx
mov		ebx, [esi + (eax * 4)]
cmp		edx, 0
je		isEven
mov		eax, ebx
jne		Ender

isEven:
	mov		ecx, [esi + (eax * 4) - 4]
	add		ebx, ecx
	mov		eax, ebx
	xor		edx, edx
	mov		ebx, 2
	div		ebx

Ender:
	; Output median result
	mov		edx, titleString
	call	WriteString
	call	WriteDec
	call	CrLf
	call	CrLf
	ret
displayMedian endp

displayList proc, array:ptr, userCount:DWORD, titleString:ptr, spaceString:ptr, outputCount:DWORD
; Receives: Array reference, user-provided input, reference to string label, reference to string of spaces, variable for data storage
; Returns: Printed representation of array
; ----------------------------------------------------------------------------------------------------------
; Clear ecx and set ecx as output counter, set newline counter, set index counter, move array address to esi
xor		ecx, ecx
mov		ebx, 10
mov		ecx, userCount
mov		outputCount, 0
mov		esi, array

; Output string label
mov		edx, titleString
call	WriteString
call	CrLf

	printNext:
		; Incrementally output given array values, separated by white space or newline
		mov		eax, 0
		mov		edx, outputCount
		mov		eax, [esi + (edx * 4)]
		call	WriteDec
		inc		edx
		mov		outputCount, edx

		mov		edx, spaceString
		call	WriteString

		dec		ebx
		cmp		ebx, 0
		je		newLine

		cmp		ecx, 1
		je		ender

		loop	printNext

	newLine:
		call	CrLf
		mov		ebx, 10
		loop	printNext
		
	ender:	
		call	CrLf
		call	CrLf
		ret
displayList endp

farewell proc, endString:ptr
; Receives: string reference
; Returns: Printed representation of farewell message
; ----------------------------------------------------------------------------------------------------------
	call	CrLf
	mov		edx, endString
	call	WriteString
	call	CrLf
	call	CrLf

	ret
farewell endp
end main
