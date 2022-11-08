jmp skipthis

print_string:	
pusha		; Routine: output string in SI to screen
	mov ah, 0Eh		; int 10h 'print char' function
.pauseforkey:
    ;mov ah, 00h   
    ;int 16h
    ;mov al,0
mov ah,0
int 0x10
mov bh,0
mov ah,2
mov dh,0
mov dl,0
int 10h
.repeat:
mov ah, 0Eh	
	lodsb			; Get character from string
	cmp al, 0
	je .done		; If char is zero, end of string
	int 10h			; Otherwise, print it
    mov bh,0
    mov ah,03h
    int 10h	
    cmp dh, 18h
    je .pauseforkey
	jmp .repeat


.done:
popa
	ret


print_char:
mov ah , 0x0e ; int =10/ ah =0 x0e -> BIOS tele - type output
int 0x10 ; print the character in al
ret


get_key: ;return al SCANCODE   why this is here is because its a left over from when I was tinkering with the disk call still going to keep it because the user program maybe need it			
    in al, 0x60
ret

;on that note might as well add the wait mill call

wait_mill:
mov al, 0
mov ah, 86h
mov cx, 1
mov dx, bx
int 15h
ret

;PS the compiled build does not have this its just a after thought


wait_for_key: ;return ah scancode al accsi
    mov ah, 00h   
    int 16h
ret
skipthis:

	