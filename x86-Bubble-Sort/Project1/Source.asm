TITLE MASM Template(main.asm)
INCLUDE Irvine32.inc
.data
	keyInput BYTE  "Enter your student ID(後四碼):",0
	str1 BYTE "Enter your Chinese scores :",0
	str2 BYTE "Enter your Math scores    :",0
	str3 BYTE "Enter your English scores :",0;文字字串
	str4 BYTE "學 號|",0
	str5 BYTE "國文|",0
	str6 BYTE "數學|",0
	str7 BYTE "英文|",0;文字字串
	str8 BYTE "總分|",0;文字字串
	str9 BYTE "名次|",0;文字字串
	str10 BYTE "輸入錯誤 請重新輸入成績介於0~100",0;文字字串
	str11 BYTE "結束",0;文字字串
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
	Mov edx,offset keyInput					;搬入請輸入學號字串
	Call WriteString                        ;呼叫印出字串
	call ReadDec                            ;讀取為無號數放入eax
	mov [name_array+esi],ax				    ;將讀取到的ax放進姓名的陣列中
	;-------------------------------------
	Mov edx,offset str1						;搬入請輸入國文成績
	Call WriteString						;呼叫印出字串
	call ReadInt							;讀取為無號數放入eax
	cmp ax,100								;比對是否大於100
	ja Again								;若大於跳至Again
	cmp ax,0								;比對是否小於0
	jb Again								;若小於跳至Again
	mov [chinese_array+esi],ax				;若都不成立ax則放入國文陣列
	;-------------------------------------
	Mov edx,offset str2						;搬入請輸入數學成績
	Call WriteString						;呼叫印出字串
	call ReadInt							;讀取為無號數放入eax
	cmp ax,100								;比對是否大於100
	ja Again								;若大於跳至Again
	cmp ax,0								;比對是否小於0
	jb Again								;若小於跳至Again
	mov [math_array+esi],ax					;若都不成立ax則放入數學陣列
	;-------------------------------------
	Mov edx,offset str3						;搬入請輸入英文成績
	Call WriteString						;呼叫印出字串
	call ReadInt							;讀取為無號數放入eax
	cmp ax,100								;比對是否大於100
	ja Again								;若大於跳至Again
	cmp ax,0								;比對是否小於0
	jb Again								;若小於跳至Again
	mov [english_array+esi],ax				;若都不成立ax則放入英文陣列
	;-------------------------------------
	add esi,2                               ;esi+2 前往下一個儲存格
	jmp Next								;跳至Next
Again:
	Mov edx,offset str10					;搬入輸入錯誤
	Call WriteString						;呼叫印出字串
	Call Crlf								;換行
	jmp KeyIn								;重新回到輸入
Next:
	cmp ecx,1								;判斷是否ecx=1
	je Next2								;如果等於跳出迴圈
	dec ecx									;若否 ecx -1
	jmp KeyIn								;跳至KeyIn
;----------------------------------------------------------------------------
Next2:
	mov esi,0								;設esi為0
	mov ecx,6								;設次數為6
AddSum:
	mov eax,0								;ecx歸零
	add ax,[chinese_array+esi]				;ax與國文成績相加
	add ax,[math_array+esi]					;ax與數學成績相加
	add ax,[english_array+esi]				;ax與英文成績相加
	mov [sum_array+esi],ax					;把ax放入總成績陣列中
	add esi,2								;esi+2前往下一儲存格
	loop AddSum								;如果ecx大於1回到Addsum
;--------------------------------------------------------bubble sort start
	mov ecx,5								;設次數為5
	mov eax,0								;eax歸零
L2:
	push ecx								;將ecx數字壓入stack中
	mov esi,0								;將esi歸零
L3:
	movzx eax,[sum_array+esi]				;把第esi個總成績放入eax
	movzx ebx,[sum_array+esi+2]				;把第esi+2個總成績放入ebx
	cmp bx,ax								;比較ebx和eax
	jb L4									;若小於跳至L4若大於等於執行以下
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
	add esi,2								;esi+2 前往下一格儲存格
	dec ecx									;ecx次數-1
	jne L3									;如果不相同 跳至L3
	pop ecx									;將原本stack 放回 ecx
	dec ecx									;ecx次數減一
	jne L2									;跳回L2
;----------------------------------------------------------bubble sort End
;-----------------------------------------Place start
	mov ecx,6                               ;次數設為6
	mov eax,0								;eax歸零
	mov esi,0								;esi歸零
	mov di,1								;給定名次為1放進di中
	mov [place_array],1						;給一開始的儲存格為第一名
	cmp esi,0								;為第一次
	je Next3 								;跳到Next3
CountPlace:
	mov ax,[sum_array+esi]					;將第esi個總成績放入ax
	mov bx,[sum_array+esi-2]				;將第esi-2個總成績放入bx
	cmp ax,bx								;比較ax與bx
	jne Next3 								;若不相等 跳到Next3
	push ax									;將原本AX壓入stack中
	mov ax,[place_array+esi-2]				;將第esi-2個名次放入ax
	mov [place_array+esi],ax				;把第esi名次與第esi-2名次變成一樣
	pop ax									;還原原本的AX
	jmp Next4 								;跳到 Next4
Next3:
	mov [place_array+esi],di				;將名次搬入第esi個
Next4:
	inc di									;名次++
	add esi,2								;前往下一個名次儲存格
	loop CountPlace							;迴圈CountPlace
;-----------------------------------------place end
;----------------------------------------------------Print Start
	Mov edx,offset str4						;將粍字串搬進
	Call WriteString						;呼叫印出字串
	Mov edx,offset str5						;將粍字串搬進
	Call WriteString						;呼叫印出字串
	Mov edx,offset str6						;將粍字串搬進
	Call WriteString						;呼叫印出字串
	Mov edx,offset str7						;將粍字串搬進
	Call WriteString						;呼叫印出字串
	Mov edx,offset str8						;將粍字串搬進
	Call WriteString						;呼叫印出字串
	Mov edx,offset str9						;將粍字串搬進
	Call WriteString						;呼叫印出字串
	;-----------------------------------------
	mov eax,0								;eax歸零
	mov esi,0								;esi歸零
	mov ecx,6								;次數設定為6
	;-------------------------------------
PrintOther:
	call Crlf								;換行
	mov ax, [name_array+esi]				;將第esi個學號放入ax
	call WriteDec							;印出無號數十進位
	mov ax,' '								;設定ax為空白
    call WriteChar							;印出空白
	call WriteChar							;印出空白
	call WriteChar							;印出空白
	mov ax, [chinese_array+esi]				;將第esi個國文成績放入ax
	call WriteDec							;印出無號數十進位
	mov ax,' '								;設定ax為空白
    call WriteChar							;印出空白
	call WriteChar							;印出空白
	call WriteChar							;印出空白
	mov ax, [math_array+esi]				;將第esi個數學成績放入ax
	call WriteDec							;印出無號數十進位
	mov ax,' '								;設定ax為空白
    call WriteChar							;印出空白
	call WriteChar							;印出空白
	call WriteChar							;印出空白
	mov ax, [english_array+esi]				;將第esi個英文成績放入ax
	call WriteDec							;印出無號數十進位
	mov ax,' '								;設定ax為空白
    call WriteChar							;印出空白
	call WriteChar							;印出空白
	mov ax, [sum_array+esi]					;將第esi個總成績放入ax
	call WriteDec							;印出無號數十進位
	mov ax,' '								;設定ax為空白
    call WriteChar							;印出空白
	call WriteChar							;印出空白
	call WriteChar							;印出空白
	call WriteChar							;印出空白
	mov ax, [place_array+esi]				;將第esi個名次放入ax
	call WriteDec							;印出無號數十進位
	add esi,2								;前往下一個處存格
	cmp ecx,1								;比對ecx和1
	je Next5								;若等於跳出迴圈
	dec ecx									;ecx次數-1
	jmp PrintOther							;跳回PrintOther
;-------------------------------------------------------print end
Next5:
	Mov edx,offset str11					;搬入請輸入學號字串
	Call WriteString                        ;呼叫印出字串
	call ReadDec                            ;讀取為無號數放入eax
	mov stop,al				    ;將讀取到的ax放進姓名的陣列中
exit
main ENDP
END main