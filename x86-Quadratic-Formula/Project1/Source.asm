TITLE MASM Template(main.asm)
INCLUDE Irvine32.inc
.data
	str1 BYTE "Ax^2 + Bx + C = 0",0
	str2 BYTE "Enter you A :",0
	str3 BYTE "Enter you B :",0
	str4 BYTE "Enter you C :",0
	str5 BYTE "無解",0
	str6 BYTE "無限多解",0
	str7 BYTE "一解為 :",0
	str8 BYTE ".",0
	str9 BYTE "-",0
	str10 BYTE "i",0
	str11 BYTE "+",0
	str12 BYTE "X = ",0
	Anum SDWORD 0
	Bnum SDWORD 0
	Cnum SDWORD 0
	count SDWORD 0;暫存器
	count1 SDWORD 0
	count2 SDWORD 0
	quotient SDWORD 0;
	remainder SDWORD 0;
	quotient2 SDWORD 0;
	remainder2 SDWORD 0;
	
.code
main PROC
;---------------------------------讀取開始
	mov  edx,offset str1
	Call WriteString
	Call Crlf
	mov  edx,offset str2
	Call WriteString
	Call ReadInt
	mov Anum,eax
	mov  edx,offset str3
	Call WriteString
	Call ReadInt
	mov Bnum,eax
	mov  edx,offset str4
	Call WriteString
	Call ReadInt
	mov Cnum,eax

;---------------------------------讀取結束
	cmp Anum,0
	jne Next1
	cmp Bnum,0
	jne Next2
	cmp Cnum,0
	jne Next3
	mov  edx,offset str6
	Call WriteString;A,B和C都是0 為無限多解
	jmp Next4
Next3:
	mov  edx,offset str5
	Call WriteString ; A和B都是0 C為常數 為無解
	jmp Next4
;----------------------------------除法 一解 = -C/B
Next2:
	neg Cnum
	mov eax,Cnum									;將C放進eax
	mov ebx,Bnum									;將B放進ebx
	cmp ebx,0
	jns signNo1
	neg ebx
	neg eax
signNo1:
	CDQ ;補數
	IDIV ebx									 ;eax / ebx = C/B
	mov quotient,eax 							 ;將商 搬進 quotient 
	mov eax,edx									 ;將餘數放進 eax
	cmp eax,0
	jns nosign
	neg eax
	imul eax,10
	CDQ
	idiv ebx
	neg quotient
	mov remainder,eax
	mov edx,OFFSET str12
	Call WriteString
	mov edx,OFFSET str9
	Call WriteString
	mov eax,quotient
	Call WriteDec
	mov edx,OFFSET str8
	Call WriteString
	mov eax,remainder
	Call WriteDec
	JMP Next4

nosign:
	imul eax,10
	CDQ
	idiv ebx
	mov remainder,eax
	mov edx,OFFSET str12
	Call WriteString
	mov eax,quotient
	Call WriteInt
	mov edx,OFFSET str8
	Call WriteString
	mov eax,remainder
	Call WriteDec
	JMP Next4

;---------------------------------------------------------------除法 一解 結束
Next1:
	mov eax,Bnum
	imul Bnum
	mov ebx,Anum
	imul ebx,Cnum
	imul ebx,4
	SUB eax,ebx
	cmp eax,0
	je answer2						;b^2-4ac = 0  Okay
	js answer1						;b^2-4ac < 0
	;--------------------------------b^2-4ac > 0
;----------------------------------------------------------------相異跟 start
	Call Crlf
	mov eax,Bnum									;B 放進 eax
	imul Bnum    									;B*B
	mov ebx,Anum 									;A 放進 ebx
	imul ebx,Cnum 									; A*C
	imul ebx,4 										;4*A*C
	SUB eax,ebx										;B*B -4AC
	mov count,eax 									; B^2 -4AC 放進 count
	mov eax,count 									;計算根號內是否為負數
	jns nosign4
	neg count 										;若負數 變為正數
nosign4: 
	mov eax,0										;歸零
	mov ebx,0 										;歸零
square1:
	add ebx,1 										;ebx++
	mov eax,ebx
	mul eax 										;eax*eax
	cmp eax,count 									; if eax*eax < B^2 -4ac
	je out2 									
	ja out1 									
	jmp square1
out1:
	dec ebx
out2:
	mov count,ebx									;將開完根號的放進count
	mov eax,Bnum 									;將B放進eax
	neg eax 										;取負號
	SUB eax,count									; -B減掉開根號的數字
	mov count1,eax 									;把 eax放進 count1
	mov eax,Bnum									;將B放進eax
	neg eax											;取負號
	ADD eax,count									; -B加上開根號的數字
	mov ebx,Anum 									; A放進 ebx
	imul ebx,2 										; A*2
	;---------------------------------
	cmp ebx,0
	jns signNo2
	neg ebx
	neg eax
signNo2:
	CDQ 										;補數
	IDIV ebx 									;eax / ebx = -B+根號B^2-4ac / 2A
	mov quotient,eax						    ;將商 搬進 quotient 
	mov eax,edx									;將餘數放進 eax
	cmp eax,0 									;判斷餘數是否小於0
	jns nosign3 
	neg eax 									;小數點不看正負號
	imul eax,10									;餘數*10
	CDQ
	idiv ebx
	neg quotient
	mov remainder,eax
	Call Crlf
	mov edx,OFFSET str12
	Call WriteString
	mov edx,OFFSET str9
	Call WriteString
	mov eax,quotient
	Call WriteDec
	mov edx,OFFSET str8
	Call WriteString
	mov eax,remainder
	Call WriteDec
	JMP nextAnswer1
nosign3:
	imul eax,10
	CDQ
	idiv ebx
	mov remainder,eax
	Call Crlf
	mov edx,OFFSET str12
	Call WriteString
	mov eax,quotient
	Call WriteInt
	mov edx,OFFSET str8
	Call WriteString
	mov eax,remainder
	Call WriteDec
	JMP nextAnswer1
;---------------------------------------------------------
nextAnswer1:
	mov eax,count1									; 將剛剛減掉的數字count1 放進 eax
	mov ebx,Anum 									; A放進 ebx
	imul ebx,2 										; A*2
	;---------------------------------
	cmp ebx,0
	jns signNo3
	neg ebx
	neg eax
signNo3:
	CDQ 											;補數
	IDIV ebx 										;eax / ebx = -B+根號B^2-4ac / 2A
	mov quotient,eax 								; 將商 搬進 quotient 
	mov eax,edx 									;將餘數放進 eax
	cmp eax,0 										;判斷餘數是否小於0
	jns nosign5
	neg eax 										;小數點不看正負號
	imul eax,10 									;餘數*10
	CDQ
	idiv ebx
	neg quotient
	mov remainder,eax
	Call Crlf
	mov edx,OFFSET str12
	Call WriteString
	mov edx,OFFSET str9
	Call WriteString
	mov eax,quotient
	Call WriteDec
	mov edx,OFFSET str8
	Call WriteString
	mov eax,remainder
	Call WriteDec
	JMP Next4
nosign5:
	imul eax,10
	CDQ
	idiv ebx
	mov remainder,eax
	Call Crlf
	mov edx,OFFSET str12
	Call WriteString
	mov eax,quotient
	Call WriteInt
	mov edx,OFFSET str8
	Call WriteString
	mov eax,remainder
	Call WriteDec
	JMP Next4
;------------------------------------------------------------------相異跟 end
;------------------------------------------------------------------兩解 i 解 start
answer1:
	neg Bnum
	mov eax,Bnum 									;將B放進eax
	mov ebx,Anum ;將A放進ebx
	imul ebx,2
	cmp ebx,0
	jns signNoNO
	neg ebx
	neg eax
signNoNo:
	CDQ 											;補數
	IDIV ebx										;eax / ebx = -B/2A
	mov quotient,eax								; 將商 搬進 quotient
	mov eax,edx 									;將餘數放進 eax
	cmp eax,0
	jns no
	neg eax
	mov count2,1
no:
	imul eax,10
	CDQ
	idiv ebx
	mov remainder,eax
	;-------------------------------------------- -B/2A 結束
	;-------------------------------------------- ( 根號4AC-B^2 / 2A ) * i
	Call Crlf
	mov eax,Anum    							;A 放進 eax
	imul eax,Cnum  								;A*C
	imul eax,4 									;A*C*4
	mov ebx,Bnum 								;B 放進 ebx
	imul ebx,ebx								; B*B
	SUB eax,ebx 								;4AC-B^2
	mov count,eax 								; 4AC-B^2 放進 count
	mov eax,count 								;計算根號內是否為負數
	jns nosignno
	neg count 									;若負數 變為正數
nosignno: 
	mov eax,0									;歸零
	mov ebx,0 									;歸零
square3:
	add ebx,1 ;ebx++
	mov eax,ebx
	mul eax ;eax*eax
	cmp eax,count ; if eax*eax < 4ac - B^2
	je out4 ;
	ja out3 ;
	jmp square3
out3:
	dec ebx
out4:
	mov count,ebx								;將開完根號的放進count
	mov eax,Bnum 								;將B放進 eax
	mov ebx,Anum 								;  A放進 ebx
	imul ebx,2 									; A*2
	;---------------------------------
	cmp ebx,0
	jns signNono2
	neg ebx
	neg eax
signNono2:
	CDQ ;補數
	IDIV ebx 									;eax / ebx = 根號4ac-B^2 / 2A
	mov quotient2,eax 							; 將商 搬進 quotient2
	mov eax,edx 								;將餘數放進 eax
	cmp eax,0 									;判斷餘數是否小於0
	jns nosignno2
	neg eax 									;小數點不看正負號
	imul eax,10									;餘數*10
	CDQ
	idiv ebx
	neg quotient2
	mov remainder2,eax
	jmp answer5
nosignno2:
	imul eax,10
	CDQ
	idiv ebx
answer5:
	Call Crlf
	mov edx,OFFSET str12
	Call WriteString
	cmp count2,0
	je Negative1
	mov edx,OFFSET str9
	Call WriteString
Negative1:
	mov eax,quotient
	Call WriteDec
	mov edx,OFFSET str8
	Call WriteString
	mov eax,remainder
	Call WriteDec
	mov edx,OFFSET str11
	Call WriteString
	mov eax,quotient2
	Call WriteDec
	mov edx,OFFSET str8
	Call WriteString
	mov eax,remainder2
	Call WriteDec
	mov edx,OFFSET str10
	Call WriteString
	JMP nextAnswer2
;---------------------------------------------------------
nextAnswer2:
	Call Crlf
	mov edx,OFFSET str12
	Call WriteString
	cmp count2,0
	je Negative2
	mov edx,OFFSET str9
	Call WriteString
Negative2:
	mov eax,quotient
	Call WriteDec
	mov edx,OFFSET str8
	Call WriteString
	mov eax,remainder
	Call WriteDec
	mov edx,OFFSET str9
	Call WriteString
	mov eax,quotient2
	Call WriteDec
	mov edx,OFFSET str8
	Call WriteString
	mov eax,remainder2
	Call WriteDec
	mov edx,OFFSET str10
	Call WriteString
	JMP Next4
;------------------------------------------------------------------兩解 i 解 end
;------------------------------------------------------------------ 重複解 為 -B/2A  ,start
answer2:
	neg Bnum
	mov eax,Bnum 									;將B放進eax
	mov ebx,Anum 									;將A放進ebx
	imul ebx,2
	cmp ebx,0
	jns signNo4
	neg ebx
	neg eax
signNo4:
	CDQ ;補數
	IDIV ebx 									;eax / ebx = -B/2A
	mov quotient,eax 									; 將商 搬進 quotient 
	mov eax,edx 									;將餘數放進 eax
	cmp eax,0
	jns nosign1
	neg eax
	imul eax,10
	CDQ
	idiv ebx
	neg quotient
	mov remainder,eax
	mov edx,OFFSET str12
	Call WriteString
	mov edx,OFFSET str9
	Call WriteString
	mov eax,quotient
	Call WriteDec
	mov edx,OFFSET str8
	Call WriteString
	mov eax,remainder
	Call WriteDec
	JMP Next4

nosign1:
	imul eax,10
	CDQ
	idiv ebx
	mov edx,OFFSET str12
	Call WriteString
	mov remainder,eax
	mov eax,quotient
	Call WriteInt
	mov edx,OFFSET str8
	Call WriteString
	mov eax,remainder
	Call WriteDec
	JMP Next4
;--------------------------------------------------------------------重複解 為 -B/2A  ,end
;----------------------------------
Next4:
Call ReadDec
exit
main ENDP
END main