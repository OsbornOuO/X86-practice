TITLE MASM Template(main.asm)
INCLUDE Irvine32.inc
.data
	str1 BYTE "�M��� n �ӽ��",0
	str2 BYTE "�п�J n : ",0
	str3 BYTE "�� ",0
	str4 BYTE " �ӽ�Ƭ� : ",0
	str5 BYTE "�� 0 �� ��� ���s�b",0
	number DWORD 2							;�q2�}�l���Ʀr
	count DWORD 0							;��n�ӽ��
	time DWORD 0							;��J���Ʀr
	numberCheck DWORD 0						;�T�{�O�_�O��� ���L
	
.code
;-------------------------------------------�D�{��
main PROC
	mov edx,OFFSET str1
	Call WriteString
	Call Crlf
	mov edx,OFFSET str2
	Call WriteString
	Call ReadInt
	mov time,eax
	jz L3
	Call prime

	mov edx,OFFSET str3
	Call WriteString
	mov eax,count
	Call WriteDec
	mov edx,OFFSET str4
	Call WriteString
	mov eax,number
	Call WriteDec
	Call Crlf
	exit
L3:
	mov edx,OFFSET str5
	Call WriteString
	Call Crlf
exit 
main ENDP
;--------------------------------------------�D�{������
;--------------------------------------------�������� ��ƼƦr 
Prime PROC
L1:
	mov eax,count
	cmp eax,time				;�O�_���W�L��J���Ʀr
	jae endPrime				;�����X
	Call IsPrime										;�I�s�Ƶ{��
	cmp numberCheck,0
	je L2
	inc count					;�p�G�O��� count �p��+1
L2:
	inc number					;number +1 �~��j��
	jmp L1						;�S�� -> �j��
endPrime:
	dec number
	ret
Prime ENDP
;--------------------------------------------�������� ��ƼƦr ����
;--------------------------------------------�Ƶ{�� ��N�ӽ�� ��M�ӼƦr �P�_�O�_�����
IsPrime PROC
	LOCAL i:DWORD,check:DWORD
	mov i,2
	mov check,0
	mov numberCheck,1
while1:
	mov eax,number				;�� number ��i eax
	cmp i,eax					;��� number �M��a ��i�ܼ�
	jae endIsPrime				;�p�G i >= number ���XWhile1�j��
	mov eax,number				;�Y�S �N number ��i eax
	mov ebx,i
	CDQ
	idiv ebx					;number / i
	cmp edx,0
	jne L1						;�Y ����0 ����L1
	mov numberCheck,0			;�l�Ƭ�0 ������� �]��0
	jmp endIsPrime				;�Y �@��0 ���X
L1:
	inc i
	jmp while1
endIsPrime:
	ret
IsPrime ENDP
;--------------------------------------------�P�_�O�_����� ����
END main