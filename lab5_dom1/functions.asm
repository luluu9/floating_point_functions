.686
.model flat

public _avg_harm

.code

; push ebp: ebp
; return address: ebp+4
; float* arr: ebp+8 -> esi
; unsigned int n: ebp+12 -> ecx
_avg_harm proc
	push ebp 
	mov ebp, esp
	
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

end