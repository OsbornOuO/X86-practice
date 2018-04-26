TITLE MASM Template(main.asm)
INCLUDE Irvine32.inc
.data
	Msg1 BYTE "�п�J A :",0;��r�r��
	Msg2 BYTE "�п�J B :",0;��r�r��
	Msg3 BYTE "�п�J C :",0;��r�r��
	Msg4 BYTE "�п�J D :",0;��r�r��
	Msg5 BYTE "�[ :",0;��r�r��
	Msg6 BYTE "�� :",0;��r�r��
	Msg7 BYTE "�� :",0;��r�r��
	Msg8 BYTE "�� :",0;��r�r��
	Msg9 BYTE "�w",0
	Msg10 BYTE " ",0
	Msg11 BYTE "    ",0
	Msg12 BYTE "�L�N�q",0
	Msg13 BYTE " = ",0
	Msg14 BYTE ".",0
	Anum SDWORD 0
	Bnum SDWORD 0
	Cnum SDWORD 0
	Dnum SDWORD 0
	count DWORD 0
	molecular SDWORD 0       ;���l
	denominator SDWORD 0		;����
.code
main PROC
	Mov EDX,OFFSET Msg1;�N�N�r��h�i
	Call WriteString;�I�s�L�X�r��
	Call ReadInt
	Mov Anum,eax
	Mov EDX,OFFSET Msg2;�N�N�r��h�i
	Call WriteString;�I�s�L�X�r��
	Call ReadInt
	Mov Bnum,eax
	Mov EDX,OFFSET Msg3;�N�N�r��h�i
	Call WriteString;�I�s�L�X�r��
	Call ReadInt
	Mov Cnum,eax
	Mov EDX,OFFSET Msg4;�N�N�r��h�i
	Call WriteString;�I�s�L�X�r��
	Call ReadInt
	Mov Dnum,eax

	mov edx,OFFSET Msg5
	Call WriteString
	Call plus
	mov edx,OFFSET Msg6
	Call WriteString
	Call less
	mov edx,OFFSET Msg7
	Call WriteString
	Call multiply
	mov edx,OFFSET Msg8
	Call WriteString
	Call except
exit
;-----------------------------------------------�D�{������
;-------------------------------------�Ƶ{���}�l
;------------------------------�[start
plus PROC
	mov eax,Bnum
	imul Dnum
	mov denominator,eax
	cmp denominator,0
	jne noZero
	mov edx,OFFSET Msg12
	Call WriteString
	Call Crlf
	ret
noZero:
	mov eax,Anum
	imul Dnum
	mov ebx,Bnum
	imul ebx,Cnum
	ADD eax,ebx
	jnz noZero2
	Call WriteDec
	Call Crlf
	ret
noZero2:
	mov molecular,eax
	cmp denominator,0
	
	Call reduction
	ret
plus ENDP
;------------------------------�[end
;-----------------------------------------------
;------------------------------��start
less PROC
	mov eax,Bnum
	imul Dnum
	mov denominator,eax
	cmp denominator,0
	jne noZero
	mov edx,OFFSET Msg12
	Call WriteString
	Call Crlf
	ret
noZero:
	mov eax,Anum
	imul Dnum
	mov ebx,Bnum
	imul ebx,Cnum
	SUB eax,ebx
	jnz noZero2
	Call WriteDec
	Call Crlf
	ret
noZero2:
	mov molecular,eax
	Call reduction
	ret
less ENDP
;------------------------------��end
;-----------------------------------------------
;------------------------------��start
multiply PROC
	mov eax,Bnum
	imul Dnum
	mov denominator,eax
	cmp denominator,0
	jne noZero
	mov edx,OFFSET Msg12
	Call WriteString
	Call Crlf
	ret
noZero:
	mov eax,Anum
	imul Cnum
	mov molecular,eax
	cmp molecular,0
	jnz noZero2
	Call WriteDec
	Call Crlf
	ret
noZero2:
	Call reduction
	ret
multiply ENDP
;------------------------------��end
;-----------------------------------------------
;------------------------------��start
except PROC
	mov eax,Bnum
	imul Cnum
	mov denominator,eax
	cmp denominator,0
	jne noZero
	mov edx,OFFSET Msg12
	Call WriteString
	Call Crlf
	ret
noZero:
	mov eax,Anum
	imul Dnum
	mov molecular,eax
	cmp molecular,0
	jnz noZero2
	Call WriteDec
	Call Crlf
	ret
noZero2:
	Call reduction
	ret
except ENDP
;------------------------------��end
;-----------------------------------------------
;------------------------------����start
reduction PROC
	mov count,0						;�̤j���]���k0
	mov eax,molecular				;���l��i eax
	cmp eax,0
	jg nosign1						;�P�_�O�_������
	neg eax							;�Y�O ���G�ɼ�
nosign1:							
	mov ebx,denominator				;������i eax
	cmp ebx,0
	jg nosign2						;�P�_�O�_������
	neg ebx							;�Y�O ���G�ɼ�
nosign2:

flounder:							;����۰��k���̤j���]�ưj��
	cmp eax,ebx						;������l�P����
	je endflounder					;�p�G�ۦP ���X�j��
	cmp count,1						;����̤j���]�ƬO�_��1
	je endflounder					;�p�G�̤j���]�Ƭ�1 ���X�j��

	cmp eax,ebx						;������l�����֤j
	ja Mbig							;�Y���l�j ���� M Big
	SUB ebx,eax						;���� - ���l
	mov count,ebx					;��i count
	jmp flounder					;�j��
Mbig:
	SUB eax,ebx						;���l - ����
	mov count,eax					;��i count
	jmp flounder					;�j��
endflounder:
	mov eax,molecular				;�N���l��i eax
	CDQ								;�ݮi
	idiv count						;���H�̤j���]��
	mov molecular,eax				;�N ���������Ʀr��^ ���l

	mov eax,denominator				;�N������i eax
	CDQ								;�ݮi
	idiv count						;���H�̤j���]��
	mov denominator,eax				;�N���������Ʀr��^ ����
	Call print
	ret 
reduction ENDP
;------------------------------����end
print PROC
	mov eax,denominator
	jns nosign
	neg molecular
	neg denominator
nosign:
	Call Crlf
	Call Crlf
	mov edx,OFFSET Msg11
	Call WriteString
	mov eax,molecular				;���L�X
	cmp eax,0
	jg Msign
	Call WriteInt
	jmp next
Msign:
	mov edx,OFFSET Msg10
	Call WriteString
	Call WriteDec
Next:
	Call Crlf
	mov edx,OFFSET Msg11
	Call WriteString
	mov edx,OFFSET Msg9
	Call WriteString
	Call Crlf
	mov edx,OFFSET Msg11
	Call WriteString
	mov eax,denominator
	Call WriteInt
	mov edx,OFFSET Msg13
	Call WriteString

	mov eax,molecular
	CDQ 
	idiv denominator
	Call WriteInt
	mov eax,edx
	mov edx,OFFSET Msg14
	Call WriteString
	imul eax,10
	CDQ
	idiv denominator
	cmp eax,0
	jg sign
	neg eax
	Call WriteDec
	Call Crlf
	ret
sign:
	Call WriteDec
	Call Crlf
	ret
print ENDP
;-------------------------------------�Ƶ{������
main ENDP
END main