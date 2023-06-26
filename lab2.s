bits	64
;	Heap Sorting
section	.data
n:
	dd	4
m:
	dd	3
matrix:
	dd	13, 14, 15
	dd	18, -19, 37
	dd	83, 88, 89
	dd	-4, 13, 7
min:
	dd	0, 0
	dd	1, 0
	dd	2, 0
	dd	3, 0
result:
	dd	0, 0, 0
	dd	0, 0, 0
	dd	0, 0, 0
	dd	0, 0, 0
section	.text
global	_start
_start:
	mov		ecx, [n]
	cmp		ecx, 1
	jle		exit

	mov		r15d, [m]
	sal		r15d, 2
	xor		ecx, ecx
m1:
	cmp		ecx, [n]
	jge		m4

	mov		ebx, matrix
	mov		eax, 1
	imul	ecx
	imul	r15d
	add		ebx, eax
		
	xor		edi, edi
	mov		eax, [ebx]
m2:
	inc		edi
	cmp		edi, [m]
	jge		m3
	cmp		eax, [ebx+edi*4]
	cmovg	eax, [ebx+edi*4]
	jmp		m2
m3:
	mov		[min+ecx*8+4], eax
	inc		ecx
	jmp		m1
m4:
	mov		ecx, [n]
	dec		ecx
	xor		edx, edx
	xor		edi, edi
	mov		ebx, min
	mov		eax, [min+edi*8+4]
m5:
	cmp		edi, ecx
	jge		m6

	cmp		eax, [min+edi*8+12]
	
%ifdef 		UP
			jle		m5nx
%elifdef	DOWN
			jge		m5nx
%endif
	
	mov		r8d, [min+edi*8+12]
	mov		[min+edi*8+4], r8d
	mov		[min+edi*8+12], eax

	mov		r8d, [min+edi*8+8]
	mov		r9d, [min+edi*8]
	mov		[min+edi*8+8], r9d
	mov		[min+edi*8], r8d
	jmp		m5f
m5nx:
	mov		eax, [min+edi*8+12]
m5f:
	inc		edi
	jmp		m5
m6:
	mov		eax, [min+edi*8+4]
m7:
	cmp		edi, edx
	jle		m8

	cmp		eax, [min+edi*8-4]

%ifdef		UP
			jge		m7nx	
%elifdef	DOWN
			jle		m7nx
%endif

	mov		r8d, [min+edi*8-4]
	mov		[min+edi*8+4], r8d
	mov		[min+edi*8-4], eax

	mov		r8d, [min+edi*8-8]
	mov		r9d, [min+edi*8]
	mov		[min+edi*8-8], r9d
	mov		[min+edi*8], r8d
	jmp		m7f
m7nx:
	mov		eax, [min+edi*8-4]
m7f:
	dec		edi
	jmp		m7
m8:
	dec		ecx
	inc		edx

	cmp		ecx, edx
	jle		m9

	jmp		m5
m9:
	xor		edi, edi
m10:	
	cmp		edi, [n]
	jge		m13

	xor		ebx, ebx
	mov		eax, [min+edi*8]
	imul	r15d
	add		ebx, eax

	xor		edx, edx
	mov		eax, edi
	imul	r15d
	add		edx, eax
	
	xor		esi, esi
m11:
	cmp		esi, [m]
	jge		m12
	
	mov		r14d, [matrix+ebx]
	mov		[result+edx], r14d

	add		ebx, 4
	add		edx, 4
	inc		esi
	jmp		m11	
m12:
	inc		edi
	jmp		m10
m13:
	mov		eax, [n]
	mov		ecx, [m]
	imul	ecx

	xor		esi, esi
m14:
	cmp		esi, eax
	jge		exit

	mov		r14d, [result+esi*4]
	mov		[matrix+esi*4], r14d

	inc		esi
	jmp		m14
exit:
	mov		eax, 60
	mov		edi, 0
	syscall
