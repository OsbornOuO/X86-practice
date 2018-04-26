TITLE MASM Template(main.asm)
INCLUDE Irvine32.inc
.data
Msg1 BYTE "Hello word!",0;¤å¦r¦r¦ê
.code
main PROC
Mov EDX,OFFSET Msg1;±NÓN¦r¦ê·h¶i
Call WriteString;©I¥s¦L¥X¦r¦ê
Call Crlf;´«¦æ
exit
main ENDP
END main
