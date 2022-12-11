.686
.model flat
.XMM

public _sum_vectors
public _int2float

.code

; function sums two arrays containing sixteen 4-bit chars vertically, e.g. results[0]=arr1[0]+arr2[0]
; note: adding these using paddsb instruction is adding with saturation, so results doesn't overflow
; ebp+16: results_arrays
; ebp+12: array_2
; ebp+8: array_1
; ebp+4: call address
; ebp: ebp
_sum_vectors proc
	push ebp
	mov ebp, esp
	
	mov eax, [ebp+8] ; array_1 ptr
	mov ebx, [ebp+12] ; array_2 ptr
	mov edi, [ebp+16] ; result_array ptr

	movups xmm0, [eax] ; move to xmm0 register
	movups xmm1, [ebx]
	paddsb xmm0, xmm1

	movups [edi], xmm0

	pop ebp
	ret
_sum_vectors endp

; ebp+12: floats array
; ebp+8: integer array
; ebp+4: call address
; ebp: ebp
_int2float proc
	push ebp
	mov ebp, esp
	
	mov eax, [ebp+8] ; integer ptr
	mov ebx, [ebp+12] ; floats ptr

	; this instructions converts only two integers (2x32-bits) to floats
	; so second 64-bits is not used
	cvtpi2ps xmm0, QWORD PTR [eax] 
	movups [ebx], xmm0

	pop ebp
	ret
_int2float endp

end
