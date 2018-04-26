TITLE MASM Template(main.asm)
INCLUDE Irvine32.inc
.data
	str1 BYTE "尋找第 n 個質數",0
	str2 BYTE "請輸入 n : ",0
	str3 BYTE "第 ",0
	str4 BYTE " 個質數為 : ",0
	str5 BYTE "第 0 個 質數 不存在",0
	number DWORD 2							;從2開始的數字
	count DWORD 0							;第n個質數
	time DWORD 0							;輸入的數字
	numberCheck DWORD 0						;確認是否是質數 布林
	
.code
;-------------------------------------------主程式
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
;--------------------------------------------主程式結束
;--------------------------------------------紀錄次數 質數數字 
Prime PROC
L1:
	mov eax,count
	cmp eax,time				;是否找到超過輸入的數字
	jae endPrime				;有跳出
	Call IsPrime										;呼叫副程式
	cmp numberCheck,0
	je L2
	inc count					;如果是質數 count 計次+1
L2:
	inc number					;number +1 繼續迴圈
	jmp L1						;沒有 -> 迴圈
endPrime:
	dec number
	ret
Prime ENDP
;--------------------------------------------紀錄次數 質數數字 結束
;--------------------------------------------副程式 第N個質數 第M個數字 判斷是否為質數
IsPrime PROC
	LOCAL i:DWORD,check:DWORD
	mov i,2
	mov check,0
	mov numberCheck,1
while1:
	mov eax,number				;把 number 放進 eax
	cmp i,eax					;比較 number 和當地 的i變數
	jae endIsPrime				;如果 i >= number 跳出While1迴圈
	mov eax,number				;若沒 將 number 放進 eax
	mov ebx,i
	CDQ
	idiv ebx					;number / i
	cmp edx,0
	jne L1						;若 不為0 跳至L1
	mov numberCheck,0			;餘數為0 不為質數 設為0
	jmp endIsPrime				;若 　為0 跳出
L1:
	inc i
	jmp while1
endIsPrime:
	ret
IsPrime ENDP
;--------------------------------------------判斷是否為質數 結束
END main