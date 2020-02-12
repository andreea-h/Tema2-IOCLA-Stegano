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
    my_new_img: resd 10000000
    
section .text

;functia "my_codify" primeste ca parametru valoarea unei key si aplica asupra matricii din [img] operatia xor folosind acea cheie
my_codify:
    push ebp
    mov ebp, esp
    
    mov ebx, [img]
    mov ecx, [ebp+8]  ;valoarea unei key
    
    xor edi, edi  ;edi este folosit ca indice pentru a itera prin matricea [img]
    xor esi, esi  ;esi este folosit ca indice de linie pentru a determina la fiecare iterare linia din matrice pe care ne situam
matrix:    
    mov edx, [ebx+4*edi]   ;edx contine pixel-ul curent din matrice
    push ecx ;save ecx
    xor edx, ecx    ;aplic asupra pixelululi curent valoare lui key, preluat din ecx 
    mov [ebx+4*edi], edx  ;pun ce am obtinut dupa xor in matrice, la adresa aferenta pixelului curent
    pop ecx ;saved ecx
    inc edi
    
    mov eax, edi  ;impartind edi la [img_width] determin la fiecare iterare daca s-a ajuns la ultima coloana a matriciis
    xor edx, edx
    div dword [img_width]
    cmp edx, 0  ;daca restul impartirii lui edi la [img_width] este 0, voi incrementa indicele de linie
    je next
    jmp matrix

next: 
    inc esi   ;merg la urmatoarea linie din matrice
    cmp esi, [img_height] ;verific daca s-a ajuns la ultima linie a matricii
    je exit3
    jmp matrix
   
exit3:
    leave
    ret
    
    
bruteforce_singlebyte_xor:
    push ebp
    mov ebp, esp
    
    mov ebx, [ebp+8] ; ebx contine adresa imaginii
    xor ecx, ecx
   
    xor esi, esi        ;indice de linie, indica linia matricii pe care ne situam la parcurgerea acesteia
    xor edi, edi        ;indice de coloana
  
    mov ecx, 1     ;ecx contine numerele care simuleaza key  
    mov eax, ecx
generate_key:
    xor esi, esi    ;esi contine la fiecare pas linia parcursa a matricii 
    xor edi, edi    ;edi este indexul prin intermediul caruia ne deplasam prin matrice    
matrix_view:
    mov edx, [ebx+4*edi]   ;edx contine pixel-ul curent din matrice
    push ecx ;save cx
    xor edx, ecx    
    pop ecx  ;saved ecx
    
    ;voi compara pixelul curent xorat cu caracterul 'r'
    ;daca s-a gasit caracterul 'r', voi compara urmatorii pixeli xorati cu urmatoarele litere din "revient"
    ;daca una din litere nu este gasita, voi merge la urmatorul pixel din matrice,pornind din nou compararea de la caracterul "r"
    cmp edx, 'r'    
    jne char_not_founded  ; daca nu s-a obtinut prin xorare caracterul 'r', atunci voi merge catre urmatorul pixel al matricii
    mov edx, [ebx+4*edi+4]  ; aici se va ajunge in cazul in care s-a gasit caracterul 'r' 
    
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
 
    push edi  ;save edi
    xor edi, edi
decode_message:
    push eax ;save eax
    mov eax, esi ;se calculeaza indicele aferent pixelului care trebuie xorat, folosind esi pentru a indica linia matricii
    imul dword [img_width]
    add eax, edi    ;eax contine indicele prin care identific elementul din matrice care trebuie xorat
    mov edx, [ebx+4*eax]
    inc edi
    pop eax  ;saved eax
    push ecx ;save ecx
    xor edx, ecx
    pop ecx ;saved ecx
    ;afisez mesajul decodificat caracter cu caracter
    PRINT_CHAR edx
    cmp edx, 46 ;caracterul '.' ne indica daca s-a ajuns la finalul mesajului
    jne decode_message  ;daca nu s-a gasit caracterul '.' continui parcurgerea
    NEWLINE             ;key si line vor fi afisate dupa ce s-a afisat mesajul decodat complet
    PRINT_UDEC 1, ecx   ;key folosita pentru codificare
    NEWLINE
    PRINT_UDEC 4, esi  ;linia la care s-a gasit mesajul codat
    NEWLINE
    mov eax, ecx
    pop edi
    jmp exit1
char_not_founded:   ;se continua parcurgerea catre urmatorul element din matrice
    inc edi ;se incrementeaza indicele pentru a merge catre urmatorul element din matrice
    mov eax, edi
    xor edx, edx 
    div dword [img_width]   
    cmp edx, 0
    je next_line
    jmp matrix_view

next_line: 
    inc esi ;incrementez indicele de linie
    cmp esi, [img_height] ;verific daca s-a ajuns la ultima linie a matricii
    je exit2
    jmp matrix_view
exit2:
    inc ecx  ;generez o noua valoarea a lui key
    cmp ecx, 255 ;ne oprim cu generarea valorilor la valoarea maxima care incape pe un octet
    jne generate_key
exit1:
    leave
    ret

;am redefinit functia aferenta taskul 1 pentru a o folosi la task2, cu eliminarea operatiilor de printare a mesajului, cheii, indexului
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
    xor esi, esi     ;indice de linie
    xor edi, edi     ;indicele cu care iterez prin matrice
    
matrix_view1:
    push edi ;save edi
    mov edx, [ebx+4*edi]   ;edx contine pixel-ul curent din matrice
    push ecx
    xor edx, ecx    
    pop ecx
    ;voi compara pixelul curent xorat cu caracterul 'r'
    ;daca s-a gasit caracterul 'r', voi compara urmatorii pixeli xorati cu urmatoarele litere din "revient"
    ;daca una din litere nu este gasita, voi merge la urmatorul pixel din matrice,pornind din nou compararea de la caracterul "r"
    cmp edx, 'r'    
    jne char_not_founded1   ; daca nu s-a obtinut prin xorare caracterul 'r', atunci voi merge catre urmatorul pixel al matricii
    mov edx, [ebx+4*edi+4]  ; aici se va ajunge in cazul in care s-a gasit caracterul 'r' 
    push ecx  ;save ecx
    xor edx, ecx
    pop ecx
    cmp edx, 'e'
    jne char_not_founded1
 
    mov edx, [ebx+4*edi+8]
    push ecx
    xor edx, ecx
    pop ecx  ;saved ecx
    cmp edx, 'v'
    jne char_not_founded1
    
    mov edx, [ebx+4*edi+12]
    push ecx
    xor edx, ecx
    pop ecx
    cmp edx, 'i'
    jne char_not_founded1
    
    push edi ;save edi
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
    
    cmp edx, 46 ; caracterul '.'
    jne decode_message1
    mov eax, ecx
    pop edi
    jmp exit11
char_not_founded1:
    pop edi  ;saved edi
    inc edi
    mov eax, edi
    xor edx, edx
    div dword [img_width]
    cmp edx, 0
    je next_line1
    jmp matrix_view1

next_line1: 
    inc esi
    cmp esi, [img_height]
    je exit21
    jmp matrix_view1
    
exit21:
    inc ecx
    cmp ecx, 255  ; ecx contine valorea lui key folosit la xorarea matricii
    jne generate_key1
  
exit11:
    leave
    ret

;functia "add_line" primeste ca parametru adresa imaginii si linia la care trebuie inserat mesajul nostru in matricea asociata imaginii
add_line:
    push ebp
    mov ebp, esp
    
    mov ebx, [ebp+8]   ;adresa imaginii
    mov ecx, [ebp+12]  ;linia dupa care se la face inserarea
    
    xor edi, edi  ;edi contine indicele prin intermediul caruia accesam el. din matrice, vizualizand matricea ca pe un vector
    xor esi, esi  ;esi este folosit pentru a identifica linia pe care ne situam in cadrul parcurgerii matricii
add_in_matrix:    
    push edi
    mov edx, [ebx+4*edi]   ;edx contine pixel-ul curent din matrice
    pop edi 
    inc edi
    mov eax, edi
    xor edx, edx
    div dword [img_width]
    cmp edx, 0 ; daca restul impartirii indicelui memorat in edi la 4 este 0, s-a ajuns la ultima coloana a matricii 
    je nextt   ; se continua parcurgerea catre urmatoare linie a matricii
    jmp add_in_matrix

nextt: 
    cmp esi, ecx  ;verific daca am ajuns la linia la care trebuie facuta inserare
    jne go_away   ; in cazul in care esi indica chiar linia primita ca parametru, se insereaza in matrice mesajul dat
insert:
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
    mov dword [ebx+4*edi+108],0    ;se adauga terminatorul de sir      
go_away:
    inc esi   ;merg la urmatoarea linie din matrice
    cmp esi, [img_height]  ;verifica daca s-a ajuns la ultima linie a matricii
    je outt
    jmp add_in_matrix
outt:
    leave
    ret

morse_encrypt:
    push ebp
    mov ebp, esp
    
    mov ebx, [ebp+8]  ; adresa imaginii (int*)
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
    ;dupa fiecare litera adaugata in matrice se adauga si ' '
put_comma: 
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
     ;se adauga in matrice caracterul terminator de sit
     dec edx
     mov [ebx+4*edx],dword 0
     jmp go_out
another_try:
     ;daca nu s-a ajuns la finalul mesajului care trebuie codat, se continua parcurgerea
     inc esi
     inc edx
     jmp make_morse_message
 
go_out:
    ;afiseaza matricea obtinuta in urma codarii
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
    
    mov ebx, [ebp+8] ;adresa imaginii
    
    mov edi, [img_width]
    mov esi, 1   ;esi contine indexul primei linii a matricii initiale care va fi accesata
    add edi, 1   ;edi contine initial indexul primului element din matricea initiala care va fi accesat

;la adresa identificata prin 'my_new_img' salvez valorile din matricea initiala
;salvarea valorilor se face in ordinea parcurgeii matricii initiale pe linii
    pusha  ;save all registers
    xor edi, edi
    xor eax, eax
    xor esi, esi
construct_my_matrix:  ;voi pune la adresa identificata prin 'my_new_img' toate valorile din matricea initiala
    push ebx  ;save ebx
    mov ebx, [img]
    mov edx, [ebx+4*edi]   ;edx contine pixel-ul curent din matrice 
    mov [my_new_img+4*edi], edx
    pop ebx   ;;saved ebx

    inc edi  ;folosesc edi pentru a 'itera' prin matrice
    ;verific daca s-a ajuns la penultima coloana a matricii
    inc eax ;eax este folosit pentru a 'itera' pe coloane; cand eax devine egal cu [img_width] se trece la urmatoarea linie
    push ecx  ;save ecx
    mov ecx, [img_width]
    cmp eax, ecx
    pop ecx  ;saved ecx
    je next_lineeee
    jmp construct_my_matrix

next_lineeee: 
    xor eax, eax  ;reseteaza indicele de coloana
    inc esi   ;ne deplasam la urmatoarea linie din matrice
    ;verific daca s-a ajuns la ultima linie a matricii
    push ecx  
    mov ecx, [img_height]
    cmp esi, ecx  
    pop ecx
    je continuare
    jmp construct_my_matrix
       
continuare:
    popa  ;saved registers
    mov eax,1  ; parcurgerea matricii pentru calculul matricii modificate se face incepand de la a doua coloana
my_matrix:    
    push ebx  ;;save ebx
    mov ebx, [img]
    mov edx, [ebx+4*edi]   ;edx contine initial pixel-ul curent din matrice 
    ;edx va memora suma folosita ulterior in calculul elementelor noii matrici
    pop ebx   ;;saved ebx
    
    add edx, [ebx+4*edi+4]  ;el. din dreapta elementului curent
    add edx, [ebx+4*edi-4]  ;el. din stanga elementului curent
    
    push edi   ;save edi
    sub edi, [img_width]
    add edx, [ebx+4*edi]  ;;el. de pe linia precedenta liniei el. curent
    pop edi    ;saved edi
    
    push edi   ;save edi
    add edi, [img_width]
    add edx, [ebx+4*edi]  ;;el. de pe linia urmatoare liniei el. curent
    pop edi    ;saved edi
  
    ;determinam restul impartirii sumei celer patru elemente la 5
    push eax ;save eax
    mov eax, edx
    push ecx ;save ecx
    mov ecx, 5
    cdq  ;extensia bitului de semn
    div ecx
    pop ecx  ;saved ecx
   
    mov edx, eax ;edx memoreaza catul impartirii
    pop eax ;saved eax
 
    push ebx ;save ebx
    mov [my_new_img+4*edi], edx  ;pune in "matricea rezultat" noile elemente ale matricii modificate
    pop ebx ;saved ebx
    push edx  
    
    inc edi  ;folosim edi pentru a 'itera' prin matrice
    ;verific daca s-a ajuns la penultima coloana a matricii
    inc eax
    push eax
    push ecx  ;save ecx
    mov ecx, [img_width]
    sub ecx, 1 
    cmp eax, ecx
    pop ecx  ;saved ecx
    pop eax
    je next_lineee
    jmp my_matrix

next_lineee: 
    mov eax,1
    add edi,2 ; modific edi a.i. prima si ultima coloana a matricii nu vor fi modificate
    inc esi   ;ne deplasam la urmatoarea linie din matrice
    ;verific daca s-a ajuns la ultima linie a matricii
    push ecx  
    mov ecx, [img_height]
    sub ecx,1
    cmp esi, ecx  ;se parcurge matricea pana la penultima linie 
    pop ecx
    je exittt 
    jmp my_matrix
  
exittt: 
    xor edi, edi
    xor eax, eax
    xor esi, esi
; voi pune in matricea [img] noua matrice modificata preluand de la adresa [my_new_img] noile valori calculate anterior
construct_my_blurred_matrix:
    push ebx  ;;save ebx
    mov ebx, [img]
    mov edx, [my_new_img+4*edi]   ;edx contine pixel-ul curent din matrice 
    mov [ebx+4*edi], edx  ;pune in matricea [img] noua matrice rezultat
    pop ebx   ;;saved ebx

    inc edi  ;folosim edi pentru a 'itera' prin matrice
    ;verific daca s-a ajuns la penultima coloana a matricii
    inc eax
    push ecx  ;save ecx
    mov ecx, [img_width]
    cmp eax, ecx
    pop ecx  ;saved ecx
    je next_lineeeee
    jmp construct_my_blurred_matrix

next_lineeeee: 
    xor eax, eax
    inc esi   ;ne deplasam la urmatoarea linie din matrice
    ;verific daca s-a ajuns la ultima linie a matricii
    push ecx  
    mov ecx, [img_height]
    cmp esi, ecx  ;se parcurge matricea pana la penultima linie 
    pop ecx
    je finally_outtt
    jmp construct_my_blurred_matrix
       
finally_outtt:
    ;se afiseaza matricea obtinuta
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
  
    mov ebx, [ebp+8]  ; adresa imaginii (int*)
    mov edx, [ebp+12] ; mesajul (char**)
    mov edi, [ebp+16] ; index (int)
    
    xor esi, esi
    dec edi ; "indexarea" incepe cu 0, dece este nevoie sa decrementez indexul primit ca argument
    
    ;determin lungimea mesajului care va fi criptat
get_string_length:
    movzx eax, byte [ecx+esi]  ;pune in eax byte-ul curent din mesaj
    inc esi   
    cmp eax, 0  ;comparand caracterul curent cu terminatorul de sir, verific daca s-a ajuns la finalul mesajului
    jne get_string_length
    push edx
    mov eax, esi
    push ecx
    mov ecx,8
    mul ecx ;inmultesc numarul de caractere din mesaj cu 8, pentru a obtine numarul de biti din reprezentarea mesajului
    pop ecx
    mov esi, eax ;rezultatul inmultirii este preluat din eax
    dec esi ;decrementez rezultatul intrucat voi considera 'indexarea' incepand cu 0
    pop edx
    ;esi va contine lungimea mesajul care trebuie codat, calculata in functie de numarul de biti din reprezentarea acestuia
    xor ecx, ecx  
    
    ;voi prelua fiecare bit din mesaj in registrul esi
bit_by_bit:  
    push esi ;save esi
    push edx ;save edx
    push edi ;save edi
    mov eax, ecx 
    mov edi, 8
    cdq
    idiv edi
    pop edi
    pop edx ;saved edx
    push ebx
    
    ;eax va contine catul impartirii lui 'ecx' la 8
    mov bl, byte [edx+eax]
    movzx esi, bl  ;bitul curent din mesaj este plasat in 'esi'
    pop ebx  ;saved ebx
    ;indicele bit-ului care trebuie accesat este restul impartirii lui cl la 8
    push ecx  ;save ecx
    push edx  ;save edx
    push edi
    mov eax, ecx 
    mov edi, 8
    cdq
    idiv edi
    mov ecx,7
    sub ecx, edx  ;edx este restul impartirii la 8 al lui ecx
    shr esi, cl   ;voi seta ca avand valoarea 1 in esi bitul de indice cl
    and esi,1     
    pop edi
    pop edx ;saved edx
    pop ecx ;saved ecx

    push ecx
    mov ecx, [ebx+4*edi] ;ecx este elementul curent din matrice
    and ecx,1   ;ecx contine LSB-ul numarului
    cmp ecx, esi  ;compar LSB-ul elementului curent din matrice cu bitul curent din mesaj
    je cont   ;daca bitii precizati anterior sunt egali, atunci nu trebuie facuta nicio modificare asupra acelui pixel din matrice
    jl aduna
    dec dword [ebx+4*edi] ;daca bitul din mesaj este 0 iar bitul din matrice este 1, am decrementat valoarea din pixelul curent
    jmp cont
aduna:
    inc dword [ebx+4*edi] ;daca bitul din mesaj este 1 iar bitul din matrice este 0, am incrementat valoarea din pixelul curent
    jmp cont
cont:
    pop ecx
    add edi,1 ;se deplasam catre urmatorul pixel am matricii 
    pop esi  ;saved esi
    cmp ecx, esi ;verific daca s-a ajuns la finalul mesajului care trebuie codificat
    je outtt
    inc ecx 
    jmp bit_by_bit      
outtt:
    ;afiseaza matricea obtinuta dupa codificare
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
    dec ecx ;am decrementat indexul intrucat am considerat indexarea incepand de la 0
    xor esi, esi  ;esi este indicele bitului obtinut odata cu fiecare pixel al matricii
    xor eax, eax
    
get_lsb:
    push ebx  ;save edx
    mov ebx,[img]
    mov eax, [ebx+4*ecx]  ;eax contine valoarea pixelului curent din matrice
    pop ebx  ;saved ebx
    
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
    
    pop eax ;saved eax: eax contine lsb al byteului curent din matrice
    mov edi, eax
    push ecx
    mov ecx, edx
    shl edi, cl  ;voi seta bitul de indice cl din eax cu valoarea continuta in registrul edi
    pop ecx
  
decode_bit:
    push edx
    push edi
    push eax ;save eax
    
    mov eax, esi
    mov edi, 8
    cdq
    idiv edi   ;determin restul impartii lui esi la 8
    pop eax ;saved eax
    pop edi
    pop edx
    cmp edx, 7  ;daca restul impartirii lui esi la 8 nu este 7, s-a reusit decodarea unui byte
    jne decode_it
    xor ebx, ebx 
decode_it:
    add ebx, edi
    cmp edx,0
    jne nexxt
    cmp ebx,0 ;daca s-a obtinut caracterul terminator de sir, s-a finalizat decodarea
    je go_outt
    PRINT_CHAR ebx ;afiseaza caracterului obtinut prin decodarea ultimilor 8 biti
nexxt:
    inc ecx
    inc esi
    cmp esi,160  ;160 este numarul maxim de biti din reprezentarea mesajului
   
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
    push DWORD[eax +4]  
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
    ;dupa apelul de mai sus: ecx contine key
    ;esi contine linia mesajului criptat
    ; voi calcula valoarea pentru noua cheie conform formulei din enunt, urmand sa o trasmit ca argument functiei care realizeaza codificarea
    mov eax, ecx
    add eax, eax ;echivalend cu *2
    add eax, 3
    push ecx ;save ecx
    mov ecx,dword 5
    cdq   ;extensia bitului de semn din eax in edx
    div ecx
    pop ecx
    sub eax, 4
    
    mov edi, eax  ;edi contine noua valoare pentru key
   
    push esi   ;save esi
    push edi   ; noul key care va fi folosit la codare (save edi)
    
    push ecx   ;key determinat la task1
    call my_codify   ;se aplica vechiul key pe intreaga matrice
    add esp, 4
    
    pop edi     ;saved edi
    pop esi     ;saved esi
    ;functia urmatoare va insera mesajul in matrice dupa linia indicata in esi
    push edi 
    push esi
    push dword [img]
    call add_line  
    add esp, 8
    pop edi ;saved edi
    
    ;functia urmatoare aplica noua cheia pe intreaga matrice in care am inserat mesajul 
    push edi ; noua valoare a lui key este trimisa ca argument functiei "my_codify"
    call my_codify
    add esp,4
    ;este afisata noua matrice
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
    ;convertesc indexul primit ca argument la int, apeland functia 'atoi'
    push ecx  ;save ecx
    push edx
    call atoi
    add esp,4
    mov edx, eax 
    pop ecx  ;saved ecx
    ;rezultatul functiei 'atoi' este preluat din eax
    
    push edx
    push ecx ; adresa mesajului (char **)
    push dword [img]    ; int* img
    call morse_encrypt
    add esp, 12
    jmp done
    
solve_task4:
    mov ecx, [ebp+12]
    mov ecx, [ecx+12]  ;mesajul care trebuie criptat cu tehnica LSB
    mov edx, [ebp+12]  
    add edx, 16
    mov edx, [edx]   ;edx contine adresa pentru argv4 (indexul dat)
    ;convertesc indexul preluant din argument la int, apeland functia 'atoi'
    push ecx  ;save ecx
  
    push edx
    call atoi
    add esp,4
    mov edx, eax 
   
    pop ecx  ;saved ecx
    ;rezultatul functiei 'atoi' este preluat din eax
    push edx   ; indexul incepand de la care este criptat mesajul
    push ecx   ;adresa mesajului (char **)
    push dword [img]    ;int* img
    call lsb_encode
    add esp, 12
    jmp done
    
solve_task5:
    mov ecx, [ebp+12] ;byte-ul incepand de la care este criptat mesajul in imagine
    mov ecx, [ecx+12] 
    ;ecx contine adresa byte-ul de start 
    ;apelez functia atoi pentru a converti argumentul la int
    push ecx
    call atoi
    add esp,4
    mov ecx, eax ;rezultatul functiei 'atoi' este preluat din eax
    ;trimit ca parametri adresa imaginii si byte-ul incepand de la care este criptat mesajul
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
    