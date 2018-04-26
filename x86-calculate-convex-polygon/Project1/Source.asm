TITLE MASM Template(main.asm)
INCLUDE Irvine32.inc
.data
	str1 BYTE "請輸入有幾個點:",0
	str2 BYTE "請輸入第 ",0
	str3 BYTE "個點的X = ",0
	str4 BYTE "Y = ",0
	str5 BYTE "交換",0
	count DWORD 1
	number DWORD 0
	Anum SDWORD 0
	Bnum SDWORD 0
	Cnum SDWORD 0
	Snum SDWORD 0

	Adec SDWORD 0
	Bdec SDWORD 0
	Cdec SDWORD 0
	Sdec SDWORD 0
	AreaNum SDWORD 0
	AreaDec SDWORD 0
COORD_ STRUCT
	X SDWORD ?
 	Y SDWORD ?
COORD_ ENDS
	AllPoints COORD_ 20 DUP(<0,0>)
.code
;-------------------------------------------主程式
main PROC
	mov edx,OFFSET str1
	Call WriteString
	Call ReadDec
	mov number,eax
	mov ecx,number
	mov esi,0
L1:
	mov edx,OFFSET str2
	Call WriteString
	mov eax,count
	Call WriteDec
	mov edx,OFFSET str3
	Call WriteString

	Call ReadInt
	mov [AllPoints+esi].X,eax

	mov edx,OFFSET str4
	Call WriteString

	Call ReadInt
	mov [AllPoints+esi].Y,eax
	add esi,TYPE COORD_                     ;※重點※
	inc count
	Loop L1
	Call Bubble_sortY
	Call Bubble_sortX
	Call ckeckPoint
	Call CountABC

	cmp AreaDec,10
	jnae Next2
	mov ebx,10
	mov eax,AreaDec
	CDQ 
	idiv ebx
	ADD AreaNum,eax
	mov AreaDec,edx
Next2:
	mov eax,AreaNum
	call WriteInt
	mov eax,AreaDec
	call WriteInt
exit
main ENDP
;--------------------------------------------
Bubble_sortX PROC
	mov ecx,number							;設次數為5
	dec ecx
	mov eax,0								;eax歸零
	mov edi,0
L2:
	push ecx								;將ecx數字壓入stack中
	mov edi,0								;將esi歸零
L3:
	mov eax,[AllPoints+edi].X
	mov ebx,[AllPoints+edi+TYPE COORD_].X
	cmp ebx,eax								;比較ebx和eax
	jae L4									;若大於跳至L4若大於等於執行以下
	mov [AllPoints+edi].X,ebx
	mov [AllPoints+edi+TYPE COORD_].X,eax

	mov eax,[AllPoints+edi].Y
	mov ebx,[AllPoints+edi+TYPE COORD_].Y
	mov [AllPoints+edi].Y,ebx
	mov [AllPoints+edi+TYPE COORD_].Y,eax
L4:
	add edi,TYPE COORD_ 					;esi+2 前往下一格儲存格
	LOOP L3									;如果不相同 跳至L3
	pop ecx									;將原本stack 放回 ecx
	LOOP L2									;跳回L2
	ret
Bubble_sortX ENDP
;--------------------------------------------
;--------------------------------------------
Bubble_sortY PROC
	mov ecx,number							;設次數為5
	dec ecx
	mov eax,0								;eax歸零
	mov edi,0
L2:
	push ecx								;將ecx數字壓入stack中
	mov edi,0								;將esi歸零
L3:
	mov eax,[AllPoints+edi].Y
	mov ebx,[AllPoints+edi+TYPE COORD_].Y
	cmp ebx,eax								;比較ebx和eax
	jbe L4									;若大於跳至L4若大於等於執行以下
	mov [AllPoints+edi].Y,ebx
	mov [AllPoints+edi+TYPE COORD_].Y,eax

	mov eax,[AllPoints+edi].X
	mov ebx,[AllPoints+edi+TYPE COORD_].X
	mov [AllPoints+edi].X,ebx
	mov [AllPoints+edi+TYPE COORD_].X,eax
L4:
	add edi,TYPE COORD_ 					;esi+2 前往下一格儲存格
	LOOP L3									;如果不相同 跳至L3
	pop ecx									;將原本stack 放回 ecx
	LOOP L2									;跳回L2
	ret
Bubble_sortY ENDP
;--------------------------------------------
;--------------------------------------------
ckeckPoint PROC
	LOCAL num:DWORD,now:DWORD;
	mov edi,0
	mov ecx,number  ;6
	sub ecx,2 ;4
	mov num,ecx ;4
L1:
	cmp ecx,0
	jne L5
	ret
L5:
	mov eax,[AllPoints+edi].X;2
	mov ebx,[AllPoints+edi+TYPE COORD_].X;2
	mov edx,[AllPoints+edi+TYPE COORD_+TYPE COORD_].X;2
	cmp eax,ebx
	jne L2
	cmp eax,edx
	jne L2
	mov now,edi ; 0
	mov num,ecx
	dec number
L3:
	mov eax,[AllPoints+edi+TYPE COORD_+TYPE COORD_].X ;1
	mov ebx,[AllPoints+edi+TYPE COORD_+TYPE COORD_].Y ;3
	mov [AllPoints+edi+TYPE COORD_].X,eax;1
	mov [AllPoints+edi+TYPE COORD_].Y,ebx;4
	ADD edi,TYPE COORD_
	Loop L3
	dec num
	mov edi,now
	mov ecx,num
	cmp ecx,0
	jne L1
	ret
L2:
	dec ecx
	cmp ecx,0
	jne L4
	ret
L4:
	ADD edi,TYPE COORD_
	jmp L1
ckeckPoint ENDP
;--------------------------------------------
print PROC
	mov ecx,number
	mov esi,0
L1:
	mov eax,[AllPoints+esi].X
	Call WriteInt
	mov eax,[AllPoints+esi].Y
	Call WriteInt
	Call Crlf
	ADD esi,TYPE COORD_
	LOOP L1
	Call crlf
	ret
print ENDP
;--------------------------------------------
;------------------------------------------------------海龍公式 S,
CountABC PROC
	LOCAL now:DWORD,count2:DWORD,ScratchS:DWORD,ScratchA:DWORD,ScratchB:DWORD,ScratchC:DWORD
	Call print
;-------------------------------------------邊長A start
BigWhile:
	cmp number,3
	jae start1
	ret
start1:
	mov now,0
	mov eax,[AllPoints].X
	mov ebx,[AllPoints].Y
	SUB eax,[AllPoints+TYPE COORD_].X
	SUB ebx,[AllPoints+TYPE COORD_].Y
	imul eax,eax
	imul ebx,ebx
	ADD eax,ebx
	imul eax,100
	cmp eax,0
	jae nosign1
	neg eax
nosign1:
	mov ebx,0 										;歸零
square1:
	inc now 										;ebx++
	mov ebx,now
	imul ebx,ebx										;eax*eax
	cmp ebx,eax 									; if eax*eax < B^2 -4ac
	je out2 									
	ja out1 									
	jmp square1
out1:
	dec now
out2:
	mov eax,now
	mov ebx,10
	CDQ 
	idiv ebx
	mov Anum,eax
	mov Adec,edx
;--------------------------------------------邊長A end
;--------------------------------------------邊長B start
	mov now,0
	mov eax,[AllPoints+TYPE COORD_].X
	mov ebx,[AllPoints+TYPE COORD_].Y
	SUB eax,[AllPoints+TYPE COORD_+TYPE COORD_].X
	SUB ebx,[AllPoints+TYPE COORD_+TYPE COORD_].Y
	imul eax,eax
	imul ebx,ebx
	ADD eax,ebx
	imul eax,100
	cmp eax,0
	jae nosign2
	neg eax
nosign2:
	mov ebx,0 										;歸零
square2:
	inc now 						
	mov ebx,now
	imul ebx,ebx							
	cmp ebx,eax 								
	je out4								
	ja out3 									
	jmp square2
out3:
	dec now
out4:
	mov eax,now
	mov ebx,10
	CDQ
	idiv ebx
	mov Bnum,eax
	mov Bdec,edx
;--------------------------------------------邊長B end
;--------------------------------------------邊長C start
	mov now,0

	mov eax,[AllPoints].X
	mov ebx,[AllPoints].Y
	SUB eax,[AllPoints+TYPE COORD_+TYPE COORD_].X
	SUB ebx,[AllPoints+TYPE COORD_+TYPE COORD_].Y
	imul eax,eax
	imul ebx,ebx
	ADD eax,ebx
	imul eax,100
	cmp eax,0
	jae nosign3
	neg eax
nosign3:
	mov ebx,0 										;歸零
square3:
	inc now 										;ebx++
	mov ebx,now
	imul ebx,ebx										;eax*eax
	cmp ebx,eax 									; if eax*eax < B^2 -4ac
	je out6 									
	ja out5 									
	jmp square3
out5:
	dec now
out6:
	mov eax,now
	mov ebx,10
	CDQ 
	idiv ebx
	mov Cnum,eax
	mov Cdec,edx
;--------------------------------------------邊長C end
;--------------------------------------------S start
	mov count2,0
	mov eax,Adec
	add eax,Bdec
	add eax,Cdec
	cmp eax,10
	jnae bigThan
	SUB eax,10
	inc count2
	mov ebx,2
	CDQ
	idiv ebx
	mov Sdec,eax
	jmp GoTo2
bigThan:
	mov Sdec,eax
GoTo2:
	mov ebx,2
	mov eax,Anum
	add eax,Bnum
	add eax,Cnum
	add eax,count2
	CDQ 
	idiv ebx
	mov Snum,eax
	mov eax,edx
	imul eax,10
	CDQ 
	idiv ebx
	ADD Sdec,eax
	mov eax,Snum
	mov ebx,Sdec
;---------------------------------------S end
;---------------------------------------海龍
	mov eax,Snum
	imul eax,10
	ADD eax,Sdec
	mov ScratchS,eax

	mov eax,0
	mov ebx,0
	mov eax,Anum
	imul eax,10
	ADD eax,Adec
	mov ebx,ScratchS
	SUB ebx,eax
	mov ScratchA,ebx

	mov eax,0
	mov ebx,0
	mov ebx,Bnum
	imul ebx,10
	ADD ebx,Bdec
	mov eax,ScratchS
	SUB eax,ebx
	mov ScratchB,eax

	mov eax,0
	mov ebx,0
	mov ebx,Cnum
	imul ebx,10
	ADD ebx,Cdec
	mov eax,ScratchS
	SUB eax,ebx
	mov ScratchC,eax

	mov eax,0
	mov ebx,0
	mov eax,ScratchS
	imul ScratchA
	imul ScratchB
	imul ScratchC
	CDQ
	mov ebx,100
	idiv ebx
	cmp eax,0
	jnb sign
	neg eax
sign:
;----------------------------------------------
	mov ebx,0 										;歸零
	mov now,0
square4:
	inc now 						
	mov ebx,now
	imul ebx,ebx							
	cmp ebx,eax 								
	je out8								
	ja out7 									
	jmp square4
out7:
	dec now
out8:
	mov eax,now
	mov ebx,10
	CDQ
	idiv ebx
	ADD AreaNum,eax
	ADD AreaDec,edx
	Call crlf
	Call crlf
	;----副程
	cmp number,3
	jne NEXT
	ret
NEXT:
	Call deletePoint
	jmp BigWhile
;---------------------------------------海龍 end
	ret
CountABC ENDP
;--------------------------------------------
deletePoint PROC
	mov ecx,number
	mov edi,0
	mov eax,[AllPoints].Y
	cmp eax,[AllPoints+TYPE COORD_].Y		;
	jb L1									;1>2↓
	mov eax,[AllPoints+TYPE COORD_].Y
	cmp eax,[AllPoints+TYPE COORD_+TYPE COORD_].Y ;2若比3大
	jb L3									;2>3↓
	dec number
	jmp for1
L3:
	mov eax,[AllPoints].Y
	cmp eax,[AllPoints+TYPE COORD_+TYPE COORD_].Y
	jb L4									;1>3↓
	dec number
	jmp change
L4:
	dec number
	jmp for1
L1:											;1<2↓
	mov eax,[AllPoints+TYPE COORD_].Y
	cmp eax,[AllPoints+TYPE COORD_+TYPE COORD_].Y
	ja L2									;2<3
	dec number
	jmp for1
L2:
	mov eax,[AllPoints].Y
	cmp eax,[AllPoints+TYPE COORD_+TYPE COORD_].Y
	dec number
	ja for1									;1>3
											;1<3↓
change:
	mov edx,OFFSET str5
	Call WriteString
	mov eax,[AllPoints].X
	mov ebx,[AllPoints].Y
	mov [AllPoints+TYPE COORD_].X,eax
	mov [AllPoints+TYPE COORD_].Y,eax
	Call crlf
for1:
	mov eax,[AllPoints+edi+TYPE COORD_].X ;1
	mov ebx,[AllPoints+edi+TYPE COORD_].Y ;3
	mov [AllPoints+edi].X,eax;1
	mov [AllPoints+edi].Y,ebx;4
	ADD edi,TYPE COORD_
	Loop for1
	Call print
	ret
deletePoint ENDP
;--------------------------------------------
END main