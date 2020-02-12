%include "include/io.inc"

extern atoi
extern printf
extern exit

; Functions to read/free/print the image.
; The image is passed in argv[1].
extern read_image
extern free_image
; void print_image(int* image, int width, int height);
extern print_image
; Get image's width and height.
; Store them in img_[width, height] variables.
extern get_image_width
extern get_image_height

section .data
	use_str db "Use with ./tema2 <task_num> [opt_arg1] [opt_arg2]", 10, 0

section .bss
    task:       resd 1
    img:        resd 1
    img_width:  resd 1
    img_height: resd 1

section .text

my_codify:
    push ebp
    mov ebp, esp
    
    mov ebx, [img]
    mov ecx, [ebp+8]
    xor edi, edi
    xor esi, esi
matrix:    
    push edi
    add edi, 1
    dec edi
    mov edx, [ebx+4*edi]   ;edx contine pixel-ul curent din matrice
    push ecx
    xor edx, ecx    ;aplicam cheia gasite pe toata matricea  
    mov [ebx+4*edi], edx  ;pun ce am obtinut dupa xor in matrice
    pop ecx
    pop edi 
  ;  PRINT_UDEC 4, edx  ;dupa decodare
  ;  PRINT_STRING " "
    inc edi
    mov eax, edi
    xor edx, edx
    div dword [img_width]
    cmp edx, 0
    je next
    jmp matrix

next: 
    inc esi   ;merg la urmatoarea linie din matrice
  ;  NEWLINE
    cmp esi, [img_height]
    je exit3
    jmp matrix
   
  
exit3:
    leave
    ret


bruteforce_singlebyte_xor:
    push ebp
    mov ebp, esp
    
    mov ebx, [img] ;ebx contine adresa imaginii
    xor ecx, ecx
   
    xor esi, esi       ;indice de linie
    xor edi, edi        ;indice de coloana
  
    mov ecx, 1     ;ecx contine numerele care simuleaza key  
    mov eax, ecx
generate_key:
    xor esi, esi       ;indice de linie
    xor edi, edi        ;indice de coloana  
    
matrix_view:
   
    push edi
   ; add edi, 1
    ;dec edi
    mov edx, [ebx+4*edi]   ;edx contine pixel-ul curent din matrice
    push ecx
    xor edx, ecx    
    pop ecx
   
   
    cmp edx, 'r'    
    jne char_not_founded
    mov edx, [ebx+4*edi+4]
    
    push ecx
    xor edx, ecx
    pop ecx
    cmp edx, 'e'
    jne char_not_founded
 
    mov edx, [ebx+4*edi+8]
    push ecx
    xor edx, ecx
    pop ecx
    cmp edx, 'v'
    jne char_not_founded
    
    mov edx, [ebx+4*edi+12]
    push ecx
    xor edx, ecx
    pop ecx
    cmp edx, 'i'
    jne char_not_founded
    
    ;;trebuie sa afisam mesajul decodat
     push edi
     xor edi, edi
decode_message:
    push eax
  
    mov eax, esi
    imul dword [img_width]
    add eax, edi
    mov edx, [ebx+4*eax]
    inc edi
    pop eax
    push ecx
    xor edx, ecx
    pop ecx
    
    
    PRINT_CHAR edx
    cmp edx, 46 ;caracterul '.'
    jne decode_message
    
    NEWLINE
    
    PRINT_UDEC 1, ecx   ;key folosita pentru codificare
    NEWLINE
   ; push ecx
    
    PRINT_UDEC 4, esi  ;linia la care s-a gasit mesajul codat
    NEWLINE
    mov eax, ecx
   ; push esi
    pop edi
    jmp exit1
char_not_founded:
    pop edi 
  ;  PRINT_UDEC 4, edx
  ;  PRINT_STRING " "
    inc edi
    mov eax, edi
    xor edx, edx
    div dword [img_width]
    cmp edx, 0
    je next_line
    jmp matrix_view

next_line: 
    inc esi
  ;  NEWLINE
    cmp esi, [img_height]
    je exit2
    jmp matrix_view
    
exit2:
  ;  PRINT_UDEC 4, ecx
  ;  NEWLINE
    inc ecx
  ;  NEWLINE
    cmp ecx, 256
    jne generate_key
  
exit1:
    leave
    ret


bruteforce_singlebyte_xor_without_print:
    push ebp
    mov ebp, esp
    
    mov ebx, [img] ;ebx contine adresa imaginii
    xor ecx, ecx
   
    xor esi, esi       ;indice de linie
    xor edi, edi        ;indice de coloana
  
    mov ecx, 1     ;ecx contine numerele care simuleaza key  
    mov eax, ecx
generate_key1:
    xor esi, esi       ;indice de linie
    xor edi, edi        ;indice de coloana  
    
matrix_view1:
   
    push edi
   ; add edi, 1
    ;dec edi
    mov edx, [ebx+4*edi]   ;edx contine pixel-ul curent din matrice
    push ecx
    xor edx, ecx    
    pop ecx
   
   
    cmp edx, 'r'    
    jne char_not_founded1
    mov edx, [ebx+4*edi+4]
    push ecx
    xor edx, ecx
    pop ecx
    cmp edx, 'e'
    jne char_not_founded1
 
    mov edx, [ebx+4*edi+8]
    push ecx
    xor edx, ecx
    pop ecx
    cmp edx, 'v'
    jne char_not_founded1
    
    mov edx, [ebx+4*edi+12]
    push ecx
    xor edx, ecx
    pop ecx
    cmp edx, 'i'
    jne char_not_founded1
    
    ;;trebuie sa afisam mesajul decodat
     push edi
     xor edi, edi
decode_message1:
    push eax
  
    mov eax, esi
    imul dword [img_width]
    add eax, edi
    mov edx, [ebx+4*eax]
    inc edi
    pop eax
    push ecx
    xor edx, ecx
    pop ecx
    
    cmp edx, 46 ;caracterul '.'
    jne decode_message1
    mov eax, ecx
   ; push esi
    pop edi
    jmp exit11
char_not_founded1:
    pop edi 
  ;  PRINT_UDEC 4, edx
  ;  PRINT_STRING " "
    inc edi
    mov eax, edi
    xor edx, edx
    div dword [img_width]
    cmp edx, 0
    je next_line1
    jmp matrix_view1

next_line1: 
    inc esi
  ;  NEWLINE
    cmp esi, [img_height]
    je exit21
    jmp matrix_view1
    
exit21:
  ;  PRINT_UDEC 4, ecx
  ;  NEWLINE
    inc ecx
  ;  NEWLINE
    cmp ecx, 256
    jne generate_key1
  
exit11:
    leave
    ret


add_line:
    push ebp
    mov ebp, esp
    
    mov ebx, [img]   ;adresa imaginii
    mov ecx, [ebp+12]  ;linia dupa care se la face inserarea
    
    xor edi, edi
    xor esi, esi
add_in_matrix:    
    push edi
    mov edx, [ebx+4*edi]   ;edx contine pixel-ul curent din matrice
    pop edi 
  ;  PRINT_UDEC 4, edx  ;dupa decodare
  ;  PRINT_STRING " "
    inc edi
    mov eax, edi
    xor edx, edx
    div dword [img_width]
    cmp edx, 0
    je nextt
    jmp add_in_matrix

nextt: 
    cmp esi, ecx  ;verific daca am ajuns la linia la care trebuie facuta inserare
    jne go_away
    ;PRINT_STRING "aici voi insera"
insert:
    ;inc edi
    mov dword [ebx+4*edi],'C'   
    mov dword [ebx+4*edi+4],39
    mov dword [ebx+4*edi+8],'e' 
    mov dword [ebx+4*edi+12],'s' 
    mov dword [ebx+4*edi+16],'t' 
    mov dword [ebx+4*edi+20],' ' 
    mov dword [ebx+4*edi+24],'u' 
    mov dword [ebx+4*edi+28],'n' 
    mov dword [ebx+4*edi+32],' ' 
    mov dword [ebx+4*edi+36],'p' 
    mov dword [ebx+4*edi+40],'r' 
    mov dword [ebx+4*edi+44],'o' 
    mov dword [ebx+4*edi+48],'v' 
    mov dword [ebx+4*edi+52],'e' 
    mov dword [ebx+4*edi+56],'r' 
    mov dword [ebx+4*edi+60],'b' 
    mov dword [ebx+4*edi+64],'e' 
    mov dword [ebx+4*edi+68],' '
    mov dword [ebx+4*edi+72],'f' 
    mov dword [ebx+4*edi+76],'r'
    mov dword [ebx+4*edi+80],'a'
    mov dword [ebx+4*edi+84],'n'
    mov dword [ebx+4*edi+88],'c'
    mov dword [ebx+4*edi+92],'a'
    mov dword [ebx+4*edi+96],'i'
    mov dword [ebx+4*edi+100],'s'
    mov dword [ebx+4*edi+104],'.'
    mov dword [ebx+4*edi+108],0          
    
go_away:
    inc esi   ;merg la urmatoarea linie din matrice
  
   ; NEWLINE
    cmp esi, [img_height]
    je outt
    jmp add_in_matrix
outt:
    leave
    ret


;void morse_encrypt(int* img, char* msg, int byte_id)
morse_encrypt:
    push ebp
    mov ebp, esp
    
    mov ebx, [img]  ; adresa imaginii (int*)
    mov ecx, [ebp+12] ; mesajul (char**)
    mov edx, [ebp+16] ; index (int)
   
    ;codific mesajul retinut in ecx
    xor esi, esi
    xor eax, eax
make_morse_message:
    movzx eax, byte [ecx+esi]  ;eax contine byte-ul curent din mesajul dat
   
    cmp eax, 0  ;verific daca s-a ajuns la finalul mesajului
    je good_job
    ;inlocuiste caracterul cu codul morse asociat
    ;codul este plasat direct in [img]
    cmp eax, 'A'
    je put_A
    cmp eax, 'B'
    je put_B
    cmp eax, 'C'
    je put_C
    cmp eax, 'D'
    je put_D
    cmp eax, 'E'
    je put_E
    cmp eax, 'F'
    je put_F
    cmp eax, 'G'
    je put_G
    cmp eax, 'H'
    je put_H
    cmp eax, 'I'
    je put_I
    cmp eax, 'J'
    je put_J
    cmp eax, 'K'
    je put_K
    cmp eax, 'L'
    je put_L
    cmp eax, 'M'
    je put_M
    cmp eax, 'N'
    je put_N
    cmp eax, 'O'
    je put_O
    cmp eax, 'P'
    je put_P
    cmp eax, 'Q'
    je put_Q
    cmp eax, 'R'
    je put_R
    cmp eax, 'S'
    je put_S
    cmp eax, 'T'
    je put_T
    cmp eax, 'U'
    je put_U
    cmp eax, 'V'
    je put_V
    cmp eax, 'W'
    je put_W
    cmp eax, 'X'
    je put_X
    cmp eax, 'Y'
    je put_Y
    cmp eax, 'Z'
    je put_Z
    cmp eax, ','
    je put_comma
    jmp another_try
put_comma: ;si " | "
    mov [ebx+4*edx],dword 45
    inc edx
    mov [ebx+4*edx],dword 45
    inc edx
    mov [ebx+4*edx],dword 46
    inc edx
    mov [ebx+4*edx],dword 46
    inc edx
    mov [ebx+4*edx],dword 45
    inc edx
    mov [ebx+4*edx],dword 45
   ; inc edx
   ; mov [ebx+4*edx],dword ' '
  ;  inc edx
  ;  mov [ebx+4*edx],dword 124
    inc edx
    mov [ebx+4*edx],dword ' '
    jmp another_try
put_A:
    mov [ebx+4*edx],dword 46
    inc edx
    mov [ebx+4*edx],dword 45
    inc edx
    mov [ebx+4*edx],dword ' '
    jmp another_try
put_B:
    mov [ebx+4*edx],dword 45
    inc edx
    mov [ebx+4*edx],dword 46
    inc edx
    mov [ebx+4*edx],dword 46
    inc edx
    mov [ebx+4*edx],dword 46
    inc edx
    mov [ebx+4*edx],dword ' '
    jmp another_try
put_C:
     
     mov [ebx+4*edx],dword 45
     inc edx
     mov [ebx+4*edx],dword 46
     inc edx
     mov [ebx+4*edx],dword 45
     inc edx
     mov [ebx+4*edx],dword 46
     inc edx
     mov [ebx+4*edx],dword ' '
     jmp another_try
put_D:
     mov [ebx+4*edx],dword 45
     inc edx
     mov [ebx+4*edx],dword 46
     inc edx
     mov [ebx+4*edx],dword 46
     inc edx
     mov [ebx+4*edx],dword 32
     jmp another_try
put_E:
     mov [ebx+4*edx],dword 46
     inc edx
     mov [ebx+4*edx],dword ' '
     jmp another_try
put_F:
     mov [ebx+4*edx],dword 46
     inc edx
     mov [ebx+4*edx],dword 46
     inc edx
     mov [ebx+4*edx],dword 45
     inc edx
     mov [ebx+4*edx],dword 46
     inc edx
     mov [ebx+4*edx],dword ' '
     jmp another_try
put_G:
     mov [ebx+4*edx],dword 45
     inc edx
     mov [ebx+4*edx],dword 45
     inc edx
     mov [ebx+4*edx],dword 46
     inc edx
     mov [ebx+4*edx],dword ' '
     jmp another_try
put_H:
     mov [ebx+4*edx],dword 46
     inc edx
     mov [ebx+4*edx],dword 46
     inc edx
     mov [ebx+4*edx],dword 46
     inc edx
     mov [ebx+4*edx],dword 46
     inc edx
     mov [ebx+4*edx],dword ' '
     jmp another_try
put_I:
     mov [ebx+4*edx],dword 46
     inc edx
     mov [ebx+4*edx],dword 46
     inc edx
     mov [ebx+4*edx],dword ' '
     jmp another_try
put_J:
     mov [ebx+4*edx],dword 46
     inc edx
     mov [ebx+4*edx],dword 45
     inc edx
     mov [ebx+4*edx],dword 45
     inc edx
     mov [ebx+4*edx],dword 45
     inc edx
     mov [ebx+4*edx],dword ' '
     jmp another_try
put_K:
     mov [ebx+4*edx],dword 45
     inc edx
     mov [ebx+4*edx],dword 46
     inc edx
     mov [ebx+4*edx],dword 45
     inc edx
     mov [ebx+4*edx],dword ' '
     jmp another_try
put_L:
     mov [ebx+4*edx],dword 46
     inc edx
     mov [ebx+4*edx],dword 45
     inc edx
     mov [ebx+4*edx],dword 46
     inc edx
     mov [ebx+4*edx],dword 46
     inc edx
     mov [ebx+4*edx],dword ' '
     jmp another_try
put_M:
     mov [ebx+4*edx],dword 45
     inc edx
     mov [ebx+4*edx],dword 45
     inc edx
     mov [ebx+4*edx],dword ' '
     jmp another_try
put_N:
     mov [ebx+4*edx],dword 45
     inc edx
      mov [ebx+4*edx],dword 46
     inc edx
    mov [ebx+4*edx],dword ' '
    jmp another_try
put_O:
     mov [ebx+4*edx],dword 45
     inc edx 
     mov [ebx+4*edx],dword 45
     inc edx 
     mov [ebx+4*edx],dword 45
     inc edx
     mov [ebx+4*edx],dword ' '
     jmp another_try
put_P:
     mov [ebx+4*edx],dword 46
     inc edx 
     mov [ebx+4*edx],dword 45
     inc edx 
     mov [ebx+4*edx],dword 45
     inc edx
     mov [ebx+4*edx],dword 46
     inc edx 
     mov [ebx+4*edx],dword ' '
     jmp another_try
put_Q:
     mov [ebx+4*edx],dword 45
     inc edx 
     mov [ebx+4*edx],dword 45
     inc edx 
     mov [ebx+4*edx],dword 46
     inc edx
     mov [ebx+4*edx],dword 45
     inc edx
     mov [ebx+4*edx],dword ' '
     jmp another_try
put_R:  
     mov [ebx+4*edx],dword 46
     inc edx
     mov [ebx+4*edx],dword 45
     inc edx
     mov [ebx+4*edx],dword 46
     inc edx
     mov [ebx+4*edx],dword ' '
     jmp another_try
put_S:
     mov [ebx+4*edx],dword 46
     inc edx
     mov [ebx+4*edx],dword 46
     inc edx
     mov [ebx+4*edx],dword 46
     inc edx
     mov [ebx+4*edx],dword ' '
     jmp another_try
put_T:
     mov [ebx+4*edx],dword 45
     inc edx
     mov [ebx+4*edx],dword ' '
     jmp another_try
put_U:
     mov [ebx+4*edx],dword 46
     inc edx
     mov [ebx+4*edx],dword 46
     inc edx
     mov [ebx+4*edx],dword 45
     inc edx
     mov [ebx+4*edx],dword ' '
     jmp another_try
put_V:
     mov [ebx+4*edx],dword 46
     inc edx
     mov [ebx+4*edx],dword 46
     inc edx
     mov [ebx+4*edx],dword 46
     inc edx
     mov [ebx+4*edx],dword 45
     inc edx
     mov [ebx+4*edx],dword ' '
     jmp another_try
put_W:
     mov [ebx+4*edx],dword 46
     inc edx
     mov [ebx+4*edx],dword 45
     inc edx
     mov [ebx+4*edx],dword 45
     inc edx
     mov [ebx+4*edx],dword ' '
     jmp another_try
put_X:
     mov [ebx+4*edx],dword 45
     inc edx
     mov [ebx+4*edx],dword 46
     inc edx
     mov [ebx+4*edx],dword 46
     inc edx
     mov [ebx+4*edx],dword 45
     inc edx
     mov [ebx+4*edx],dword ' '
     jmp another_try
put_Y:
     mov [ebx+4*edx],dword 45
     inc edx
     mov [ebx+4*edx],dword 46
     inc edx
     mov [ebx+4*edx],dword 45
     inc edx
     mov [ebx+4*edx],dword 45
     inc edx
     mov [ebx+4*edx],dword ' '
     jmp another_try
put_Z: 
     mov [ebx+4*edx],dword 45
     inc edx
     mov [ebx+4*edx],dword 45
     inc edx
     mov [ebx+4*edx],dword 46
     inc edx
     mov [ebx+4*edx],dword 46
     inc edx
     mov [ebx+4*edx],dword ' '
     jmp another_try
good_job:
     dec edx
     mov [ebx+4*edx],dword 0
     jmp go_out
another_try:
     inc esi
     inc edx
     jmp make_morse_message
 
go_out:
     push dword [img_height]
     push dword [img_width]
     push dword [img]
     call print_image
     add esp,12
     leave
     ret 
   
blur:
    push ebp
    mov ebp, esp
    
    mov ebx, [img] ;adresa imaginii
    
     push dword [img_height]
     push dword [img_width]
     push dword [img]
     call print_image
     add esp,12 
    
    xor edi, edi
    mov edi,[img_width]
    xor esi, esi
    mov esi,1
    mov ecx, [ebx+4*edi] 
 
    
    push edi  ;save edi
    add edi, 4
    sub edi, [img_width]
    mov eax, [ebx+4*edi]
    pop edi   ;saved edi
    
    add edi, 4
    
   
my_matrix:    
    mov edx, [ebx+4*edi]   ;edx contine pixel-ul curent din matrice
 
    add edx, edx ;;!!!!!!!!!!!!!!!!!!!!!!!
    add edx, [ebx+4*edi+4]  ;el din dreapta
   ; add edx, [ebx+4*edi-4]  ;el din stanga
    add edx, ecx
    mov ecx, [ebx+4*edi] ;salvez vechiul pixel in ecx -> va fi nevoie de el la calculul urmatorului pixel
    
    push edi   ;save edi
    sub edi, [img_width]
  ;  add edx, [ebx+4*edi]  ;;el de sus
    add edx, eax
    mov eax, [ebx+4*edi] ;;el de sus este salvat in eax
    pop edi    ;saved edi
    
    push edi   ;save edi
    add edi, [img_width]
    add edx, [ebx+4*edi]  ;;el de jos
    pop edi    ;saved edi
  
    ;;impart suma(edx) la 5
    push eax
    mov eax, edx
    push ecx
    mov ecx, 5
    cdq
    div ecx
    pop ecx
   
    ;;pune catul adica rezultatul in edx
    mov edx, eax
    pop eax
    PRINT_UDEC 4, edx
    PRINT_STRING " "
  ;  mov ecx, [ebx+4*edi]  ;salvez in ecx valoarea vechiului pixel din matrice
    mov [ebx+4*edi], edx
 ;   PRINT_UDEC 4, edx  ;dupa "codare"
 ;   PRINT_STRING " "
    push edx  ;salvez pe stiva noile elemente ale matricei
    
    inc edi
    push eax
    mov eax, edi
    xor edx, edx
   
    div dword [img_width]
    pop eax
    cmp edx, 1
    je next_lineee
    jmp my_matrix

next_lineee: 
    inc esi   ;merg la urmatoarea linie din matrice
    NEWLINE
   add edi, 4
    push ecx  
    mov ecx, [img_height]
    dec ecx
    cmp esi, ecx  ;se parcurge pana la penultima linie a matricii
    pop ecx
    je exittt
    jmp my_matrix
   

exittt: 
     push dword [img_height]
     push dword [img_width]
     push dword [img]
     call print_image
     add esp,12 
     leave
     ret
   
lsb_encode:
    push ebp
    mov ebp, esp
    push dword [img_height]
    push dword [img_width]
    push dword [img]
   ; call print_image
    add esp,12
    mov ebx, [ebp+8]  ; adresa imaginii (int*)
    mov edx, [ebp+12] ; mesajul (char**)
    mov edi, [ebp+16] ; index (int)
 ;   xor edi, edi
    xor esi, esi
    dec edi ; "indexarea" incepe cu 0
  get_string_length:
    movzx eax, byte [ecx+esi]
    inc esi   ;->esi contine lungimea sirului
    cmp eax, 0
    jne get_string_length
    push edx
    mov eax, esi
    push ecx
    mov ecx,8
    mul ecx
    pop ecx
    mov esi, eax  ;esi contine lungimea sirului
    dec esi
    pop edx
  ;  PRINT_UDEC 4, esi
   ; NEWLINE
   
 
   ; push edx 
  ;  mov edx, ecx
   ; push ecx
    xor ecx, ecx
bit_by_bit:  

    push esi ;save esi
    push edx
    push edi
     mov eax, ecx 
     mov edi, 8
     cdq
     idiv edi
     pop edi
     pop edx ;saved edx
     push ebx
  ;   PRINT_UDEC 4, [edx+eax]
  ;   PRINT_STRING " "
     mov bl, byte [edx+eax]
     movzx esi, bl
     pop ebx
    ;indicele bit-ului care trebuie accesat este restul impartirii lui cl la 8
     push ecx
     push edx  ;save edx
     push edi
     mov eax, ecx 
     mov edi, 8
     cdq
     idiv edi
     mov ecx,7
     sub ecx, edx  ;edx este restul impartirii la 8 al lui ecx
    shr esi, cl   ;pentru a obtine bitul de indice cl
    and esi,1
    pop edi
    pop edx ;saved edx
    pop ecx ;saved ecx
   ; PRINT_UDEC 4, esi  ;bitul de indice cl
  ;  PRINT_STRING " "
    ;esi trebuie sa ia locul lui LSB din [ebx+4*edi]
 ;   PRINT_UDEC 4, [ebx+4*edi]
 ;   PRINT_STRING " "
 ;   PRINT_UDEC 4, edi
 ;   PRINT_STRING " "
 ;   NEWLINE
    
   ; or [ebx+4*edi], esi
   push ecx
   mov ecx, [ebx+4*edi]
   and ecx,1
  ; PRINT_UDEC 4, ecx   ;ecx contine lsb al numarului
   cmp ecx, esi
   je cont
   ;cmp ecx, esi
   jl aduna
  ; sub [ebx+4*edi],dword 1
 ;  cmp [ebx+4*edi], dword 133
 ;  je cont
   dec dword [ebx+4*edi]
   jmp cont
aduna:
   ; add [ebx+4*edi],dword 1
   inc dword [ebx+4*edi]
    jmp cont
cont:
 
   pop ecx
 ;   PRINT_UDEC 4, ecx
 ;   NEWLINE
   ;;daca lsb este 1 si esi este 0, atunci scad 1 din nr
 ;   PRINT_STRING "edi: "
 ;   PRINT_UDEC 4, edi
 ;   PRINT_STRING " "
 ;   PRINT_UDEC 4, [ebx+4*edi]

    add edi,1
 ;   NEWLINE
    pop esi
    
    cmp ecx, esi ;verific daca s-a ajuns la finalul sirului
    je outtt
    inc ecx
    jmp bit_by_bit
    
   ; pop ecx
;    NEWLINE
    ;pop edx ;;saved edx
   
      
      
outtt:
    push dword [img_height]
    push dword [img_width]
    push dword [img]
    call print_image
    add esp,12
    leave 
    ret 
    
  
lsb_decode:
    push ebp
    mov ebp, esp
    
    mov ecx, [ebp+12]  ;ecx contine byte-ul incepand de la care este criptat mesajul
    
    
    xor ebx, ebx
    dec ecx
    
    pusha
    push dword [img_height]
    push dword [img_width]
    push dword [img]
 ;   call print_image
    add esp,12
    popa
    
    xor esi, esi  ;esi este indicele bitului obtinut odata cu fiecare pixel al matricii
    xor eax, eax
get_lsb:
    push ebx
    mov ebx,[img]
    mov eax, [ebx+4*ecx]
    pop ebx
    
    and eax,1  ;eax contine lsb al elementului din matrice
    ;;setez in ebx bitul de indice [7-restul impartirii lui esi la 8] cu valoarea din eax
    ;calculez restul impartirii lui esi la 8
    push eax ;save eax
    mov eax, esi
    mov edi, 8
    cdq
    idiv edi
    mov edi, 7     ;edx contine restul impartirii lui esi la 8
    sub edi, edx  ;edi contine indicele bitului care trebuie setat cu valoarea din eax
    mov edx, edi  ;edx are indicele bitului care trebuie setat
    
    pop eax ;saved eax ->eax contine lsb al byteului curent din matrice
    ;x |= (eax << y); 
    mov edi, eax
    push ecx
    mov ecx, edx
    shl edi, cl  ;;1<<cl
    pop ecx
  
decode_bit:
    push edx
    push edi
    push eax ;save eax
    
    mov eax, esi
    mov edi, 8
    cdq
    idiv edi
    pop eax ;saved eax
    pop edi
    pop edx
    cmp edx, 7 ;;cand restul este 0
    jne asa
    xor ebx, ebx
asa:
    add ebx, edi
    cmp edx,0
    jne nexxt
    cmp ebx,0
    je go_outt
    PRINT_CHAR ebx 
nexxt:
    inc ecx
    inc esi
    cmp esi,160
   
    je go_outt   
    jmp get_lsb
    
   
go_outt:

    NEWLINE
    leave 
    ret      
    
                            
    
global main
main:
    ; Prologue
    ; Do not modify!
    push ebp
    mov ebp, esp
     
    mov eax, [ebp + 8] ;;argc-numarul de argumente
    cmp eax, 1
    jne not_zero_param

    push use_str
    call printf
    add esp, 4

    push -1
    call exit

not_zero_param:
    ; We read the image. You can thank us later! :)
    ; You have it stored at img variable's address.
    
    mov eax, [ebp + 12] 
    push DWORD[eax +4]   ;imaginea
    call read_image
    add esp, 4
    mov [img], eax
   
    ; We saved the image's dimensions in the variables below.
    call get_image_width
    mov [img_width], eax

    call get_image_height
    mov [img_height], eax

    ; Let's get the task number. It will be stored at task variable's address.
    mov eax, [ebp + 12]
    
    push DWORD[eax + 8]  ;numarul task ului
    call atoi
    add esp, 4
    mov [task], eax
   
    ; There you go! Have fun! :D
    mov eax, [task]
    cmp eax, 1
    je solve_task1
    cmp eax, 2
    je solve_task2
    cmp eax, 3
    je solve_task3
    cmp eax, 4
    je solve_task4
    cmp eax, 5
    je solve_task5
    cmp eax, 6
    je solve_task6
    cmp eax, 7
    je solve_task7
    jmp done

solve_task1:
    push dword [img]
    call bruteforce_singlebyte_xor
    add esp,4
    jmp done
solve_task2:
    push dword [img]
    ;apelez urmatoarea functie pt a obtine key si line ca la task1
    call bruteforce_singlebyte_xor_without_print
    add esp,4
    ;ecx contine key
    ;esi contine linia mesajului criptat
    
    mov eax, ecx
    add eax, eax ;echivalend cu *2
    add eax,3
    push ecx
    mov ecx,dword 5
    cdq   ;extensia bitului de semn din eax in edx
    div ecx
    pop ecx
    
    sub eax, 4
    
    mov edi, eax  ; noua valoare pentry key
   
    push esi   ;save esi
    
    push edi   ; noul key care va fi folosit la codare
    push ecx   ;key determinat la task1
  ;  push esi   ;line determinat la task1
    call my_codify   ;se aplica vechiul key pe intreaga matrice
    add esp, 4
    pop edi
    pop esi     ;saved esi
    
    ;functia urmatoare va insera mesajul in matrice dupa linia indicata in esi
 ;   PRINT_UDEC 4, esi
 ;   NEWLINE
    push edi ;save edi
    push esi
    push dword [img]
    call add_line  
    add esp, 8
    pop edi ;saved edi
    ;functia urmatoare aplica noua cheia pe intreaga matrice in care am inserat mesajul 
    
   ; PRINT_UDEC 4, edi
  ;  NEWLINE
   ; PRINT_UDEC 4, edi
   ; NEWLINE
   
pwp:
    
    push edi
    call my_codify
    add esp,4
    ;afisez noua imagine
   ; PRINT_UDEC 4, [img_height]
   ; NEWLINE
  
    push dword [img_height]
    push dword [img_width]
    push dword [img]
    call print_image
    add esp,12
    jmp done
    
solve_task3:
    mov ecx, [ebp+12]
    mov ecx, [ecx+12]  ;mesajul care trebuie criptat morse
    mov edx, [ebp+12]
    add edx, 16
    mov edx, [edx]   ;edx contine adresa pentru argv4 (indexul dat)
    ;convertesc indexul primit la int, apeland functia 'atoi'
  
    push ecx  ;save ecx
    
    push edx
    call atoi
    add esp,4
    mov edx, eax 
   
    pop ecx  ;saved ecx

     ;rezultatul functiei 'atoi' este preluat din eax
    ;ecx contine adresa mesajului -> trebuie dereferentiata adresa
   
    push edx
    push ecx ; adresa mesajului (char **)
    push dword [img]    ; int* img
    call morse_encrypt
    add esp, 16
    jmp done
solve_task4:
    mov ecx, [ebp+12]
    mov ecx, [ecx+12]  ;mesajul care trebuie criptat cu tehnica LSB
    mov edx, [ebp+12]
    add edx, 16
    mov edx, [edx]   ;edx contine adresa pentru argv4 (indexul dat)
    ;convertesc indexul primit la int, apeland functia 'atoi'
  
    push ecx  ;save ecx
    
    push edx
    call atoi
    add esp,4
    mov edx, eax 
   
    pop ecx  ;saved ecx

     ;rezultatul functiei 'atoi' este preluat din eax
    ;ecx contine adresa mesajului -> trebuie dereferentiata adresa
   
    push edx
    push ecx ; adresa mesajului (char **)
    push dword [img]    ; int* img
    call lsb_encode
    add esp, 16
    jmp done
solve_task5:
     mov ecx, [ebp+12] ;byte-ul incepand de la care este criptat mesajul
    mov ecx, [ecx+12]
   ; mov ecx, [ecx]
   ; PRINT_CHAR ecx
   ; NEWLINE
    push ecx
    call atoi
    add esp,4
    mov ecx, eax
    push ecx
    push dword [img]
    call lsb_decode
    add esp, 8

    jmp done
solve_task6:

    push dword[img]
    call blur
    add esp,4 
    
    jmp done
solve_task7:
    ; TODO Task7
    jmp done

    ; Free the memory allocated for the image.
done:
    push DWORD[img]
    call free_image
    add esp, 4

    ; Epilogue
    ; Do not modify!
    xor eax, eax
    leave
    ret
    