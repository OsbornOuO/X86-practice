TITLE MASM Template(main.asm)
INCLUDE Irvine32.inc
.data
	Msg1 BYTE "請輸入 A :",0;文字字串
	Msg2 BYTE "請輸入 B :",0;文字字串
	Msg3 BYTE "請輸入 C :",0;文字字串
	Msg4 BYTE "請輸入 D :",0;文字字串
	Msg5 BYTE "加 :",0;文字字串
	Msg6 BYTE "減 :",0;文字字串
	Msg7 BYTE "乘 :",0;文字字串
	Msg8 BYTE "除 :",0;文字字串
	Msg9 BYTE "─",0
	Msg10 BYTE " ",0
	Msg11 BYTE "    ",0
	Msg12 BYTE "無意義",0
	Msg13 BYTE " = ",0
	Msg14 BYTE ".",0
	Anum SDWORD 0
	Bnum SDWORD 0
	Cnum SDWORD 0
	Dnum SDWORD 0
	count DWORD 0
	molecular SDWORD 0       ;分子
	denominator SDWORD 0		;分母
.code
main PROC
	Mov EDX,OFFSET Msg1;將粍字串搬進
	Call WriteString;呼叫印出字串
	Call ReadInt
	Mov Anum,eax
	Mov EDX,OFFSET Msg2;將粍字串搬進
	Call WriteString;呼叫印出字串
	Call ReadInt
	Mov Bnum,eax
	Mov EDX,OFFSET Msg3;將粍字串搬進
	Call WriteString;呼叫印出字串
	Call ReadInt
	Mov Cnum,eax
	Mov EDX,OFFSET Msg4;將粍字串搬進
	Call WriteString;呼叫印出字串
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
;-----------------------------------------------主程式結束
;-------------------------------------副程式開始
;------------------------------加start
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
;------------------------------加end
;-----------------------------------------------
;------------------------------減start
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
;------------------------------減end
;-----------------------------------------------
;------------------------------乘start
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
;------------------------------乘end
;-----------------------------------------------
;------------------------------除start
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
;------------------------------除end
;-----------------------------------------------
;------------------------------約分start
reduction PROC
	mov count,0						;最大公因數歸0
	mov eax,molecular				;分子放進 eax
	cmp eax,0
	jg nosign1						;判斷是否有號數
	neg eax							;若是 取二補數
nosign1:							
	mov ebx,denominator				;分母放進 eax
	cmp ebx,0
	jg nosign2						;判斷是否有號數
	neg ebx							;若是 取二補數
nosign2:

flounder:							;輾轉相除法取最大公因數迴圈
	cmp eax,ebx						;比較分子與分母
	je endflounder					;如果相同 跳出迴圈
	cmp count,1						;比較最大公因數是否為1
	je endflounder					;如果最大公因數為1 跳出迴圈

	cmp eax,ebx						;比較分子分母誰大
	ja Mbig							;若分子大 跳到 M Big
	SUB ebx,eax						;分母 - 分子
	mov count,ebx					;放進 count
	jmp flounder					;迴圈
Mbig:
	SUB eax,ebx						;分子 - 分母
	mov count,eax					;放進 count
	jmp flounder					;迴圈
endflounder:
	mov eax,molecular				;將分子放進 eax
	CDQ								;拓展
	idiv count						;除以最大公因數
	mov molecular,eax				;將 約分完的數字放回 分子

	mov eax,denominator				;將分母放進 eax
	CDQ								;拓展
	idiv count						;除以最大公因數
	mov denominator,eax				;將約分完的數字放回 分母
	Call print
	ret 
reduction ENDP
;------------------------------約分end
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
	mov eax,molecular				;↓印出
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
;-------------------------------------副程式結束
main ENDP
END main