TITLE MASM Template(main.asm)
INCLUDE Irvine32.inc
.data
	keyInput BYTE  "Enter your student ID(��|�X):",0
	str1 BYTE "Enter your Chinese scores :",0
	str2 BYTE "Enter your Math scores    :",0
	str3 BYTE "Enter your English scores :",0;��r�r��
	str4 BYTE "�� ��|",0
	str5 BYTE "���|",0
	str6 BYTE "�ƾ�|",0
	str7 BYTE "�^��|",0;��r�r��
	str8 BYTE "�`��|",0;��r�r��
	str9 BYTE "�W��|",0;��r�r��
	str10 BYTE "��J���~ �Э��s��J���Z����0~100",0;��r�r��
	str11 BYTE "����",0;��r�r��
	name_array WORD 20 DUP(0)
	chinese_array WORD 6 DUP(0)
	math_array WORD 6 DUP(0)
	english_array WORD 6 DUP(0)
	sum_array WORD 6 DUP(0)
	place_array WORD 6 DUP(0)
	stop BYTE 0 

	baffer WORD 0
.code
main PROC
	mov ecx,6
	mov esi,0
KeyIn:
	Mov edx,offset keyInput					;�h�J�п�J�Ǹ��r��
	Call WriteString                        ;�I�s�L�X�r��
	call ReadDec                            ;Ū�����L���Ʃ�Jeax
	mov [name_array+esi],ax				    ;�NŪ���쪺ax��i�m�W���}�C��
	;-------------------------------------
	Mov edx,offset str1						;�h�J�п�J��妨�Z
	Call WriteString						;�I�s�L�X�r��
	call ReadInt							;Ū�����L���Ʃ�Jeax
	cmp ax,100								;���O�_�j��100
	ja Again								;�Y�j�����Again
	cmp ax,0								;���O�_�p��0
	jb Again								;�Y�p�����Again
	mov [chinese_array+esi],ax				;�Y��������ax�h��J���}�C
	;-------------------------------------
	Mov edx,offset str2						;�h�J�п�J�ƾǦ��Z
	Call WriteString						;�I�s�L�X�r��
	call ReadInt							;Ū�����L���Ʃ�Jeax
	cmp ax,100								;���O�_�j��100
	ja Again								;�Y�j�����Again
	cmp ax,0								;���O�_�p��0
	jb Again								;�Y�p�����Again
	mov [math_array+esi],ax					;�Y��������ax�h��J�ƾǰ}�C
	;-------------------------------------
	Mov edx,offset str3						;�h�J�п�J�^�妨�Z
	Call WriteString						;�I�s�L�X�r��
	call ReadInt							;Ū�����L���Ʃ�Jeax
	cmp ax,100								;���O�_�j��100
	ja Again								;�Y�j�����Again
	cmp ax,0								;���O�_�p��0
	jb Again								;�Y�p�����Again
	mov [english_array+esi],ax				;�Y��������ax�h��J�^��}�C
	;-------------------------------------
	add esi,2                               ;esi+2 �e���U�@���x�s��
	jmp Next								;����Next
Again:
	Mov edx,offset str10					;�h�J��J���~
	Call WriteString						;�I�s�L�X�r��
	Call Crlf								;����
	jmp KeyIn								;���s�^���J
Next:
	cmp ecx,1								;�P�_�O�_ecx=1
	je Next2								;�p�G������X�j��
	dec ecx									;�Y�_ ecx -1
	jmp KeyIn								;����KeyIn
;----------------------------------------------------------------------------
Next2:
	mov esi,0								;�]esi��0
	mov ecx,6								;�]���Ƭ�6
AddSum:
	mov eax,0								;ecx�k�s
	add ax,[chinese_array+esi]				;ax�P��妨�Z�ۥ[
	add ax,[math_array+esi]					;ax�P�ƾǦ��Z�ۥ[
	add ax,[english_array+esi]				;ax�P�^�妨�Z�ۥ[
	mov [sum_array+esi],ax					;��ax��J�`���Z�}�C��
	add esi,2								;esi+2�e���U�@�x�s��
	loop AddSum								;�p�Gecx�j��1�^��Addsum
;--------------------------------------------------------bubble sort start
	mov ecx,5								;�]���Ƭ�5
	mov eax,0								;eax�k�s
L2:
	push ecx								;�Necx�Ʀr���Jstack��
	mov esi,0								;�Nesi�k�s
L3:
	movzx eax,[sum_array+esi]				;���esi���`���Z��Jeax
	movzx ebx,[sum_array+esi+2]				;���esi+2���`���Z��Jebx
	cmp bx,ax								;���ebx�Meax
	jb L4									;�Y�p�����L4�Y�j�󵥩����H�U
	mov [sum_array+esi],bx
	mov [sum_array+esi+2],ax

	mov ax,[name_array+esi]	
	mov bx,[name_array+esi+2]
	mov [name_array+esi],bx
	mov [name_array+esi+2],ax

	mov ax,[chinese_array+esi]
	mov bx,[chinese_array+esi+2]
	mov [chinese_array+esi],bx
	mov [chinese_array+esi+2],ax

	mov ax,[math_array+esi]
	mov bx,[math_array+esi+2]
	mov [math_array+esi],bx
	mov [math_array+esi+2],ax

	mov ax,[english_array+esi]
	mov bx,[english_array+esi+2]
	mov [english_array+esi],bx
	mov [english_array+esi+2],ax
L4:
	add esi,2								;esi+2 �e���U�@���x�s��
	dec ecx									;ecx����-1
	jne L3									;�p�G���ۦP ����L3
	pop ecx									;�N�쥻stack ��^ ecx
	dec ecx									;ecx���ƴ�@
	jne L2									;���^L2
;----------------------------------------------------------bubble sort End
;-----------------------------------------Place start
	mov ecx,6                               ;���Ƴ]��6
	mov eax,0								;eax�k�s
	mov esi,0								;esi�k�s
	mov di,1								;���w�W����1��idi��
	mov [place_array],1						;���@�}�l���x�s�欰�Ĥ@�W
	cmp esi,0								;���Ĥ@��
	je Next3 								;����Next3
CountPlace:
	mov ax,[sum_array+esi]					;�N��esi���`���Z��Jax
	mov bx,[sum_array+esi-2]				;�N��esi-2���`���Z��Jbx
	cmp ax,bx								;���ax�Pbx
	jne Next3 								;�Y���۵� ����Next3
	push ax									;�N�쥻AX���Jstack��
	mov ax,[place_array+esi-2]				;�N��esi-2�ӦW����Jax
	mov [place_array+esi],ax				;���esi�W���P��esi-2�W���ܦ��@��
	pop ax									;�٭�쥻��AX
	jmp Next4 								;���� Next4
Next3:
	mov [place_array+esi],di				;�N�W���h�J��esi��
Next4:
	inc di									;�W��++
	add esi,2								;�e���U�@�ӦW���x�s��
	loop CountPlace							;�j��CountPlace
;-----------------------------------------place end
;----------------------------------------------------Print Start
	Mov edx,offset str4						;�N�N�r��h�i
	Call WriteString						;�I�s�L�X�r��
	Mov edx,offset str5						;�N�N�r��h�i
	Call WriteString						;�I�s�L�X�r��
	Mov edx,offset str6						;�N�N�r��h�i
	Call WriteString						;�I�s�L�X�r��
	Mov edx,offset str7						;�N�N�r��h�i
	Call WriteString						;�I�s�L�X�r��
	Mov edx,offset str8						;�N�N�r��h�i
	Call WriteString						;�I�s�L�X�r��
	Mov edx,offset str9						;�N�N�r��h�i
	Call WriteString						;�I�s�L�X�r��
	;-----------------------------------------
	mov eax,0								;eax�k�s
	mov esi,0								;esi�k�s
	mov ecx,6								;���Ƴ]�w��6
	;-------------------------------------
PrintOther:
	call Crlf								;����
	mov ax, [name_array+esi]				;�N��esi�ӾǸ���Jax
	call WriteDec							;�L�X�L���ƤQ�i��
	mov ax,' '								;�]�wax���ť�
    call WriteChar							;�L�X�ť�
	call WriteChar							;�L�X�ť�
	call WriteChar							;�L�X�ť�
	mov ax, [chinese_array+esi]				;�N��esi�Ӱ�妨�Z��Jax
	call WriteDec							;�L�X�L���ƤQ�i��
	mov ax,' '								;�]�wax���ť�
    call WriteChar							;�L�X�ť�
	call WriteChar							;�L�X�ť�
	call WriteChar							;�L�X�ť�
	mov ax, [math_array+esi]				;�N��esi�ӼƾǦ��Z��Jax
	call WriteDec							;�L�X�L���ƤQ�i��
	mov ax,' '								;�]�wax���ť�
    call WriteChar							;�L�X�ť�
	call WriteChar							;�L�X�ť�
	call WriteChar							;�L�X�ť�
	mov ax, [english_array+esi]				;�N��esi�ӭ^�妨�Z��Jax
	call WriteDec							;�L�X�L���ƤQ�i��
	mov ax,' '								;�]�wax���ť�
    call WriteChar							;�L�X�ť�
	call WriteChar							;�L�X�ť�
	mov ax, [sum_array+esi]					;�N��esi���`���Z��Jax
	call WriteDec							;�L�X�L���ƤQ�i��
	mov ax,' '								;�]�wax���ť�
    call WriteChar							;�L�X�ť�
	call WriteChar							;�L�X�ť�
	call WriteChar							;�L�X�ť�
	call WriteChar							;�L�X�ť�
	mov ax, [place_array+esi]				;�N��esi�ӦW����Jax
	call WriteDec							;�L�X�L���ƤQ�i��
	add esi,2								;�e���U�@�ӳB�s��
	cmp ecx,1								;���ecx�M1
	je Next5								;�Y������X�j��
	dec ecx									;ecx����-1
	jmp PrintOther							;���^PrintOther
;-------------------------------------------------------print end
Next5:
	Mov edx,offset str11					;�h�J�п�J�Ǹ��r��
	Call WriteString                        ;�I�s�L�X�r��
	call ReadDec                            ;Ū�����L���Ʃ�Jeax
	mov stop,al				    ;�NŪ���쪺ax��i�m�W���}�C��
exit
main ENDP
END main