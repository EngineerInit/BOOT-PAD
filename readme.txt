BOOT-PAD

features

big 15360 max document length
access to any storage drive not the boot one
write bytes to any value directly using a "intuitive" input system
run loaded files as programs


CONTROLS

"-" read file
"=" save file
"Esc" clears the screen (pressing backspace untill there is no saveable text will do the same thing)
"~" sawp drive
"_" run file (must be loaded first)
";" write byte
"tab" nonthing

BYTE INPUT

used for writing bytes and swaping the drive

this works by adding together all the letters you type in untill you press enter

A+A+B = 1+1+2

lower case letters are the same as upper case expect they have a 31 offset

meaning a = 32 z = 122 

note number don't work here
and will actually will negative

9+9 = -14



swap drive presets

floppy A      null = 0
floppy B      A    = 1
Harddrive A   zzO or ZZZZX = 128



programmer info

loads files at 9000 hex



IO calls

print_string
prints a null terminated string at si

print_char
prints al as a ascii char
*effects ah* 

get_key
returns al

wait_for_key
returns al ascii , ah scan code
