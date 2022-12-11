.686
.model flat

public _avg_harm
public _exp_sum

.code

; push ebp: ebp
; return address: ebp+4
; float* arr: ebp+8 -> esi
; unsigned int n: ebp+12 -> ecx
_avg_harm proc
	push ebp 
	mov ebp, esp

	finit
	mov esi, [ebp+8]
	mov ecx, [ebp+12]
	xor eax, eax ; eax used for incrementing
	fldz
start:

	fld1 ; st(0), stack is pushed down, example: st(0)->st(1)
	fdiv DWORD PTR [esi+eax*4] ; st(0)/x
	faddp st(1), st(0) ; sum previous result with new and pop st(0) moving st(1) to st(0)

	inc eax
	loop start

	; sum is ready, now divide n by it
	fild dword ptr [ebp+12] ; load n
	fdiv st(0), st(1) ; div n/sum

	pop ebp
	ret
_avg_harm endp


; ebp+8: (float) x
; ebp+4: return address
; ebp: ebp
_exp_sum proc
	push ebp
	mov ebp, esp
	
	finit
	mov ecx, 12 ; loop utilizes ecx
	mov eax, 1;

	fld1 ; current result
	fld1 ; denominator
	fld1 ; exponent
	; below is explanation why this is loaded first
start:
	; structure of fpu in this loop on start: 
	; st(0) has current i
	; st(1) has x^(i-1)
	; st(2) has 1*2*3...i-1
	; st(3) has current result
	push eax ; we can't load general registers to fpu, so use stack
	fild DWORD PTR [esp]

	; st(1) has x^(i-1), so to make x^i multiply it by x, which is not on the stack
	push DWORD PTR [ebp+8]
	fld DWORD PTR [esp] ; load x 
	add esp, 4 ; we pushed so we have to pop to align stack
	; now st(0)=x and st(2) has x^(i-1), multiply these and pop x as we don't need it anymore
	fmulp st(2), st(0)   
	; now st(1) has x^i, we have to divide it by 1*2*3...i
	; st(2) has 1*2*3...i-1, multiply this by i (its in st(0))
	fmul st(2), st(0) ; st(2) has 1*2*3...i
	; we will need st(1)=x^i and st(2)=1*2*3...i so division must be made in st(0)
	fstp st(0) ; pop st(0) which causes all stack registers to moves them down
	fld st(0) ; push st(0) to st(0) which duplicates st(0) and moves them up
	; now st(0) has x^i, lets divide it by 1*2*3...i
	fdiv st(0), st(2)
	; st(0) has result of current division, and in st(3) is previous result, lets add it
	fadd st(3), st(0)
	; we have calculated sum for i-th iteration
	; to prepare register stack for next iteration, lets pop st(0) to achieve this:
	; st(0) has x^i
	; st(1) has 1*2*3...i
	; st(2) has current result
	fstp st(0) ; pop st(0)
	
	add esp, 4 ; align stack as we pushed eax
	inc eax
	loop start

	; returned result should be on st(0), so pop others than result 
	fstp st(0) ; pop st(0)
	fstp st(0) ; pop st(0)

	pop ebp
	ret
_exp_sum endp

end
