;I know this code is copy paste crap
;but I still need to post it
;why its this way is because when I started this I did not understand the as much so I copied code form a tutorial
;then when I understood them more I changed to fit my needs still im not saying I understand everything to a T right now but im still learning
;maybe I can write a better OS/text editor thingy in the future when I know more














; Read some sectors from the boot disk using our disk_read function
	[map all myfile.map]
	BITS 16
[org 0x7c00]


mov [BOOT_DRIVE],dl 
main:

call wait_for_key



cmp al,'-'
je load
cmp al,'='
je save

cmp al,27
je clear
cmp al,'_'
je 0x9000
cmp al,9
je main
cmp al,';'
je savebyte

cmp al,';'
je savebyte

cmp ah,59
je changedrive
cmp ah,60
je changehead
cmp ah,61
je changecyl
cmp al,'+'
je loaded


call print_char
cmp al,8
je back
call store_char
cmp al,13
je newline
jmp main


load:
mov si,loadtext
call print_string
mov ah , 0x02
push ax
jmp disk
save:
;call clearscreen
mov si,savetext
call print_string

;add word [textpointer],1
;sub word [textpointer],1
mov bx ,word [textpointer]
;add bx,1
mov al,0
mov [bx],al
mov ah , 0x03
push ax
jmp disk
disk:
mov dl,[BOOT_DRIVE] ; BIOS stores our boot drive in DL , so it ’s
; best to remember this for later.
mov bp , 0x8000 ; Here we set our stack safely out of the
mov sp , bp ; way , at 0 x8000
;mov bx , 0x9000 ; Load 5 sectors to 0 x0000 ( ES ):0 x9000 ( BX )
mov bx, 0x9000
mov dh , 30 ; from the boot disk.
mov dl , [BOOT_DRIVE]
;mov ah , 0x02
call disk_load
pop ax
cmp ah,0x02
je loaded
jmp main
loaded:
call clearscreen
;mov word [textpointer],0x9000
;mov bx ,word [textpointer]
;add bx,1
;mov al,0
;mov [bx],al
mov si,0x9000
call print_string
	;mov ah, 0Eh		; int 10h 'print char' function
;mov word [textpointer],0x9000
;.repeat:
;add word[textpointer],1
;mov bx,word[textpointer]
;cmp word[bx],0
;je .done
;jmp .repeat
;.done:
;mov word [textpointer],si
mov word [textpointer],0x9000
jmp main
back:
sub word  [textpointer],1
mov ax,word  [textpointer]
cmp ax,0x9000
jl clear
jmp main

clear:
call clearscreen
mov word  [textpointer],0x9000
jmp main

jmp main
changedrive:
mov si,changedrivetext
call print_string
call getbyte
mov [BOOT_DRIVE],bl
jmp main
savebyte:
call getbyte
mov al,bl
call store_char
jmp main

changehead:
mov si,changeheadtext
call print_string
call getbyte
mov [DISK_HEAD],bl
jmp main

changecyl:
mov si,changecylindertext
call print_string
call getbyte
mov [DISK_CYLINDER],bl
jmp main

newline:
call store_char
mov al,10
call print_char
call store_char
jmp main


getbyte: ;uses al returns bl
mov bl,0
mov al,'0'
call print_char
.inputloop:
call wait_for_key
call print_char
cmp al,13
je .end
cmp al,8
je .back
sub al,64
add bl,al
jmp .inputloop

.back:

sub al,64
sub bl,al
mov al,' '
call print_char
mov al,8
call print_char




jmp .inputloop
.end:
ret

store_char:
mov bx,word  [textpointer]
mov [bx],al
add word  [textpointer],1
ret

clearscreen:



mov al,2
mov ah,0
int 0x10

;mov ah,0Bh
;mov bh,00h 
;mov bl,15
;int 0x10

ret


%include "io.asm"
%include "disk.asm"
; Include our new disk_load function
; Global variables
;videomode : db 0
savetext : db "Save",10,0
loadtext : db "Load",0
changedrivetext : db ">Drive",10,0
changeheadtext : db ">Head",10,0
changecylindertext : db ">Cylinder",10,0
textpointer : dw 0x9000
BOOT_DRIVE : db 0
; Bootsector padding
times 510 -($ - $$) db 0
dw 0xaa55
mov ah,00h
mov al,06h 
int 10h
mov bl,5
mov si,labelthatwel+1200h; < booooo
call print_string-1200h
mov ah,00h
mov al,0h
int 10h


mov al,10
mov ah,0
int 0x10


jmp main-1200h


labelthatwel: db "Welcome to Boot-Pad",10,13,"Controls",10,13,"- < load",10,13,"+ < save",10,13,"Esc < clear",10,13,"now for some Lorem Ipsum",10,13,10,13,10,13,10,13
db " Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum dignissim sem mauris, non mattis est tincidunt in. Aliquam a rhoncus lectus, at finibus diam. Proin dapibus pellentesque magna nec maximus. Aenean viverra dolor elementum pharetra hendrerit. Mauris magna tellus, tincidunt non nisl vel, mollis eleifend nisl. Integer pretium, ipsum eget vestibulum porttitor, ipsum neque commodo eros, at laoreet justo odio sit amet mi. Pellentesque sed lacinia odio. Vestibulum condimentum semper lectus, a interdum nulla venenatis sed. Vivamus vitae bibendum nulla. Cras a lacus a eros pretium rutrum a vel felis. Morbi blandit hendrerit quam, pellentesque finibus leo porttitor eu. Morbi nulla lorem, dictum sed risus at, rutrum laoreet velit. Donec ut est elit. Aliquam vulputate at magna sed porta. Sed sit amet dui mauris. Etiam massa erat, fermentum vel augue sed, lobortis tempus ipsum. Proin vitae sagittis magna, imperdiet mattis nisl. Sed egestas porta ipsum, tristique egestas nunc. Donec molestie pharetra tellus, sit amet placerat arcu convallis a. Aliquam vel rhoncus turpis. Nam auctor diam id viverra volutpat. Nullam placerat sodales nunc, nec rhoncus mi consequat vel. Nulla facilisi. Nullam nulla est, auctor non ipsum blandit, euismod varius dolor. Curabitur vel dictum est. Quisque consequat volutpat nunc, quis condimentum velit. Donec ullamcorper tempor dui, eu mattis nisl accumsan a. Nullam nisl diam, congue in risus eget, pulvinar vehicula massa. Nunc faucibus rhoncus eros sed ultrices. Nullam eget nisl convallis, aliquet elit posuere, tristique felis. Etiam ac elementum metus. Sed condimentum sodales velit, quis maximus quam congue commodo. Vivamus mollis justo in lectus mattis, commodo interdum tellus lacinia. Phasellus egestas dictum neque. Maecenas rutrum ante vel consequat tincidunt. Sed elementum ante a tellus lobortis fermentum. Praesent porttitor nec odio eu ultrices. Vestibulum suscipit rutrum mi non aliquet. Fusce nec purus nec nisl tempus pellentesque ut in nisl. Aenean accumsan, neque eu viverra auctor, massa enim dapibus elit, id aliquam nulla ante quis diam. In auctor eros commodo orci ornare consectetur. Etiam sed odio leo. Phasellus vitae mi gravida, sodales tellus id, ullamcorper risus. Proin nec tincidunt lorem. Ut malesuada posuere tincidunt. Sed ut sagittis eros. Quisque ultricies porttitor tempus. Integer sit amet hendrerit enim, vel cursus diam. Vestibulum a sollicitudin nisl. Quisque ultricies tortor nisi, vel accumsan nisl ultrices sed. In elementum pellentesque sapien. Sed sagittis velit non lorem commodo blandit. Morbi eget eros dui. Donec fringilla dignissim mauris ultricies lobortis. Sed ex quam, varius tempor lacus eget, hendrerit vehicula augue. Maecenas consequat, ligula eget blandit bibendum, massa turpis commodo lectus, vel tincidunt lacus urna non nibh. Integer ullamcorper dignissim erat, eget pharetra turpis euismod id. Vestibulum pellentesque eget massa eu egestas. Praesent porttitor diam egestas pharetra malesuada. Nunc in sapien enim. Nulla imperdiet interdum est a luctus. Sed iaculis id risus nec venenatis. Sed nisi metus, egestas sit amet nibh ut, pharetra venenatis erat. In non facilisis dui. Proin at molestie nisl. In urna enim, dictum id purus et, iaculis gravida lacus. In condimentum tempor felis, sagittis bibendum leo tincidunt sit amet. Sed dolor ipsum, efficitur nec efficitur at, fermentum sit amet felis. Quisque non diam quis justo tristique egestas. Nullam mollis eleifend ipsum sit amet egestas. Nullam bibendum luctus est, eget tristique urna fermentum quis. Suspendisse id magna urna. Nulla facilisi. Donec suscipit felis ut placerat dictum. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. In eros leo, ultricies a ante id, consectetur efficitur nulla. Sed eget hendrerit orci, quis sodales elit. Cras dictum, turpis nec efficitur efficitur, tortor purus luctus mi, sed scelerisque odio lectus eget nulla. Cras tempor felis quis mauris luctus congue. Duis at diam eros. Pellentesque eget pulvinar enim. Suspendisse et nulla nec risus varius vestibulum nec sed nulla. Nunc egestas elementum nulla, iaculis condimentum ipsum ultrices in. Aliquam in erat aliquam, scelerisque magna at, posuere mi. Pellentesque ut elit augue. Sed sit amet massa eget nisi euismod sollicitudin. Donec mattis gravida venenatis. Nullam ut metus tortor. Praesent dignissim, lorem et ornare molestie, quam risus pellentesque ipsum, at bibendum ex dui sed nunc. Vestibulum ornare sem est. Vivamus pretium nunc vel neque iaculis, non luctus felis dignissim. Nulla fermentum consequat felis, eu placerat dolor malesuada a. Cras quam diam, condimentum placerat pharetra a, tristique eu urna. Nullam quis consequat nulla, nec convallis turpis. Sed interdum vel tortor a eleifend. Vestibulum ante metus, interdum ut sapien eget, eleifend gravida erat. Maecenas porttitor sagittis diam. Maecenas ut orci eu nibh vehicula cursus. Nam fringilla hendrerit enim quis hendrerit. Donec nam. "
;times 400 db "Padin"
;times 400 db "still"
;times 400 db "what"
times 32256 -($ - $$) db 0