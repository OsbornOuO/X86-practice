TITLE MASM Template(main.asm)
INCLUDE Irvine32.inc
.data
Msg1 BYTE "Hello word!",0;��r�r��
.code
main PROC
Mov EDX,OFFSET Msg1;�N�N�r��h�i
Call WriteString;�I�s�L�X�r��
Call Crlf;����
exit
main ENDP
END main
