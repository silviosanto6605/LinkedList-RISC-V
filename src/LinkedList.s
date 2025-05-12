.data

    listInput: .string "ADD(S) ~ ADD(i) ~ ADD(l) ~ ADD(v) ~ ADD(i) ~ADD(o) ~ ADD(;) ~ ADD(9)PRINT~PRINT ~REV~SOR~PRINT~DEL(b) ~DEL(B)~PRI~PRI~NT~REV~SO~RT~~PRINT"
    

.text

la s1,listInput #salvo la testa della stringa di input che passera alla funzione di parsing
li s2,0 #HEAD_PTR puntatore alla testa della lista
li s3,0 #LAST_PTR puntatore all'ultimo elemento della lista
li s4,0 #counter dei nodi
li s5,0x10000000 #carico NEXT_FREE_ADDR, indirizzo di inizio dei dati statici
jal PARSING  #devo implementare la logica di parsing


li a7,10
ecall


PARSING:
    addi sp,sp,-4
    sw ra,0(sp)


    parsing_loop:
    
        lb t0,0(s1)
        beqz t0,end_parsing

        li t1,32 #spazio
        beq t0,t1,skip_space_or_tilde

        li t1,126 #tilde
        beq t0,t1,skip_space_or_tilde

        jal identify_command


    skip_space_or_tilde:
        addi s1,s1,1
        j parsing_loop

    end_parsing:
        lw ra,0(sp)
        addi sp,sp,4
        ret


    identify_command:   
        addi sp,sp,-4
        sw ra,0(sp)

        lb t0,0(s1)

        li t1,65    #inizia per A?
        beq t0,t1,process_add_command

        li t1, 80   #inizia per P?
        beq t0, t1, process_print_command
        
        li t1, 83   #inizia per S?
        beq t0, t1, process_sort_command
        
        li t1, 82   #inizia per R?
        beq t0, t1, process_rev_command
        
        li t1, 68   #inizia per D?
        beq t0, t1, process_del_command
        
        j invalid_command


    find_next_command:
        #vai avanti finch? non trovi o tilde o fine stringa
        lb t0,0(s1)
        beqz t0,end_parsing

        li t1,126 #tilde
        beq t0,t1, skip_space_or_tilde
        addi s1,s1,1
        j find_next_command
    

    invalid_command:
        #se il comando non ? valido, vai avanti finche non trovi o tilde o stringa (cio? salta a find_next_command)
        j find_next_command



    # PROCESSO I SINGOLI COMANDI
    # ossia controllo se rispettano il formato richiesto o sono invalidi
    # nel caso in cui siano validi, cio? la funzione di verifica mi abbia ritornato 1 e non 0
    # allora li eseguo



    process_add_command:

        jal verify_add_format
        beqz a1,invalid_command
        jal ADD
        j find_next_command

    process_print_command:
        jal verify_print_format
        beqz a0, invalid_command    
        
        jal PRINT

        j find_next_command

    process_sort_command:
        jal verify_sort_format
        beqz a0, invalid_command    
        
        jal SORT

        j find_next_command

    process_rev_command:
        jal verify_rev_format
        beqz a0, invalid_command    
        
        jal REV

        j find_next_command

    process_del_command:
        jal verify_del_format
        beqz a0, invalid_command    
        
        jal DEL

        j find_next_command




    #VERIFICA del formato -> funzione che ritorna in a1 1 se formato valido e 0 se non valido

    verify_add_format:
        addi sp,sp,-4
        sw ra,0(sp)

        addi s1,s1,1
        lb t0,0(s1)
        li t1,68 #controllo D,  carattere successivo al primo, gi? controllato
        bne t0,t1, invalid_format

        addi s1,s1,1
        lb t0,0(s1)
        li t1,68 # D
        bne t0,t1,invalid_format

        addi s1,s1,1
        lb t0,0(s1)
        li t1,40 # "("
        bne t0,t1, invalid_format

        #leggo il parametro e controllo la sua validit? (32<x<125)
        addi s1,s1,1
        lb a0,0(s1)

        li t1,32
        blt a0,t1,invalid_format
        li t1,125
        bgt a0,t1,invalid_format

        addi s1,s1,1
        lb t0,0(s1)
        li t1,41 # ")"
        bne t0,t1, invalid_format


        #Controllo terminatore

        addi s1,s1,1
        jal verify_command_terminator
        beqz a1,invalid_format

        li a1,1 #segnalo il successo mettendo in a1=1
        
        lw ra,0(sp)
        addi sp,sp,4
        ret

   






    
    verify_del_format:
        addi sp,sp,-4
        sw ra,0(sp)

        addi s1,s1,1
        lb t0,0(s1)
        li t1,69 #controllo E,  carattere successivo al primo, gi? controllato
        bne t0,t1, invalid_format

        addi s1,s1,1
        lb t0,0(s1)
        li t1,76 # L
        bne t0,t1,invalid_format

        addi s1,s1,1
        lb t0,0(s1)
        li t1,40 # "("
        bne t0,t1, invalid_format

        #leggo il parametro e controllo la sua validit? (32<x<125)
        addi s1,s1,1
        lb a0,0(s1)

        li t1,32
        blt a0,t1,invalid_format
        li t1,125
        bgt a0,t1,invalid_format

        addi s1,s1,1
        lb t0,0(s1)
        li t1,41 # ")"
        bne t0,t1, invalid_format


        #Controllo terminatore

        addi s1,s1,1
        jal verify_command_terminator
        beqz a1,invalid_format

        li a1,1 #segnalo il successo mettendo in a1=1
        
        lw ra,0(sp)
        addi sp,sp,4
        ret

   
    
    verify_rev_format:
        addi sp,sp,-4
        sw ra,0(sp)

        addi s1,s1,1
        lb t0,0(s1)
        li t1,69 #controllo E,  carattere successivo al primo, gi? controllato
        bne t0,t1, invalid_format

        addi s1,s1,1
        lb t0,0(s1)
        li t1,86 # V
        bne t0,t1,invalid_format


        #Controllo terminatore
        addi s1,s1,1
        jal verify_command_terminator
        beqz a1,invalid_format

        li a1,1 #segnalo il successo mettendo in a1=1
        
        lw ra,0(sp)
        addi sp,sp,4
        ret

    
    
    verify_sort_format:
        addi sp,sp,-4
        sw ra,0(sp)

        addi s1,s1,1
        lb t0,0(s1)
        li t1,79 # O
        bne t0,t1, invalid_format

        addi s1,s1,1
        lb t0,0(s1)
        li t1,82 # R
        bne t0,t1,invalid_format

        addi s1,s1,1
        lb t0,0(s1)
        li t1,84 # T
        bne t0,t1,invalid_format


        #Controllo terminatore
        addi s1,s1,1
        jal verify_command_terminator
        beqz a1,invalid_format

        li a1,1 #segnalo il successo mettendo in a1=1
        
        lw ra,0(sp)
        addi sp,sp,4
        ret

    verify_print_format:
        addi sp,sp,-4
        sw ra,0(sp)

        addi s1,s1,1
        lb t0,0(s1)
        li t1,82 # R
        bne t0,t1, invalid_format

        addi s1,s1,1
        lb t0,0(s1)
        li t1,73 # I
        bne t0,t1,invalid_format
        
        addi s1,s1,1
        lb t0,0(s1)
        li t1,78 # N
        bne t0,t1,invalid_format

        addi s1,s1,1
        lb t0,0(s1)
        li t1,84 # T
        bne t0,t1,invalid_format


        #Controllo terminatore
        addi s1,s1,1
        jal verify_command_terminator
        beqz a1,invalid_format

        li a1,1 #segnalo il successo mettendo in a1=1
        
        lw ra,0(sp)
        addi sp,sp,4
        ret


    invalid_format:
        li a1,0
        
        lw ra,0(sp)
        addi sp,sp,4
        ret

    
    verify_command_terminator:
        #verifica che il comando termini con un temrinatore valido (1), ritorno in a1
        addi sp, sp, -4
        sw ra, 0(sp)
        
        skip_spaces_after_command:
            lb t0, 0(s1)
            li t1, 32        # ASCII spazio
            bne t0, t1, check_terminator
            addi s1, s1, 1
            j skip_spaces_after_command
        
        check_terminator:
            # Controllo se fine stringa
            beqz t0, valid_terminator
            
            # Controllo se tilde
            li t1, 126      
            beq t0, t1, valid_terminator
            
            li a1, 0
            j end_verify_terminator
        
        valid_terminator:
            li a1, 1
        
        end_verify_terminator:
            lw ra, 0(sp)
            addi sp, sp, 4
            ret






REV:

    addi sp,sp,-4
    sw ra, 0(sp)

    #Se c'? un solo nodo, banalmente invertita
    li t0,1
    ble s4,t0,end_rev

    mv t1,s2 #parto dalla HEAD
    li t2,0 #contatore elementi pushati, mi serve dopo

    rev_push_phase:

        beqz t1, end_rev_push_phase # se il prossimo nodo ? nullo, termina push
        lb t3, 0(t1) #DATA del nodo corrente
        addi sp,sp,-4 #spreco potenziale di spazio, ma utile per evitare problemi di allineamento
        sb t3,0(sp) #pusho il DATA del nodo corrente nello stack

        addi t2,t2,1 #aumento contatore pushati
        addi t4,t1,1 #allineo al PAHEAD

        lw t1,0(t4) #carico l'indirizzo al successivo
        j rev_push_phase
    
    end_rev_push_phase:
        mv t1,s2 # ricomincio dalla HEAD per i pop
    
    rev_pop_phase:
        beqz t2, end_rev #Quando li ho poppati tutti, ho finito
        
        lb t3, 0(sp) #pop
        sb t3,0(t1) #scrivo il DATA poppato nel nodo attuale
        addi sp,sp,4
        addi t2,t2,-1

        addi t4,t1,1 #allineo al PAHEAD
        lw t1,0(t4) #carico il  nodo successivo per scriverci dentro
        j rev_pop_phase

    end_rev:
        lw ra, 0(sp)        
        addi sp, sp, 4
        ret



PRINT:

    beqz s2,end_print
    
    addi sp,sp,-4 #salvo ra
    sw ra, 0(sp)

    mv a0,s2 #passo come parametro s2, cio? la HEAD 
    jal print_recursive

    lw ra,0(sp) 
    addi sp,sp,4 #ripristino il ra

    
    end_print:
        li a0,10
        li a7,11
        ecall
        ret
    
    print_recursive:
        beqz a0, return_recursive_print #Base: se la HEAD ? zero, vuol dire che non c'? un nodo
        
        addi sp,sp,-8 #devo salvare ra e a0, che contiene il puntatore al nodo attuale
        sw ra,0(sp)
        sw a0,4(sp)

        lb a0,0(a0) # carico e stampo il carattere del nodo corrente, puntato da a0
        li a7,11
        ecall

        li a0,32 #stampo un separatore
        li a7,11 
        ecall 

        lw a0,4(sp) #riprendo il puntatore al nodo
        addi a0,a0,1 #...e mi allineo al campo PAHEAD per avere il puntatore al successivo
        lw a0,0(a0) #e infine carico la HEAD del nodo successivo
        
        jal print_recursive
        
        lw ra,0(sp)
        addi sp,sp,8 #ripristino la stack


    return_recursive_print:
        ret
        
    
    



ADD: # parametro in a0 (DATA)

    addi sp,sp,-4       
    sw ra,0(sp)                # Salva il return address nella stack

   jal find_next_free_addr    # Ritorna in a1 il prossimo indirizzo di scrittura 
    
   sb a0,0(a1)                # Scrivi DATA nel primo byte del nodo
   addi a1,a1,1               # in questo modo vado a prendere il byte successivo
   sw zero,0(a1)              # PAHEAD = 0 (ultimo nodo)
   
   addi a1,a1,-1              #siccome avevo incrementato di uno per scrivere, devo rifixare

    beq zero,s4,firstADD       # Se ? il primo nodo, salta
    sw a1,1(s3)                # Aggiorna PAHEAD del nodo precedente
    mv s3,a1                   # Aggiorna LAST_PTR
    addi s4,s4,1               # Incrementa il contatore nodi
    j end_ADD

    firstADD:
        mv s2,a1                   # HEAD_PTR = indirizzo nuovo nodo
        mv s3,a1                   # LAST_PTR = indirizzo nuovo nodo
        addi s4,s4,1               # Incrementa il contatore nodi

    end_ADD:
        lw ra,0(sp)
        addi sp,sp,4
        jr ra



DEL:
     #carattere da cercare in a0

    addi sp,sp,-4
    sb ra, 0(sp) # salvo ra
    
    beqz s2, end_DEL #controllo se ci sono nodi


    check_head_deletion: #il carattere ? nella testa?

        lb t0,0(s2) #carico il DATA del nodo HEAD 
        bne t0,a0, del_find_next # controlla se eliminarla in quanto ? presente il carattere parametro da eliminare

        addi t1,s2,1 # mi allineo al PAHEAD
        lw t1, 0(t1)  #carica il PAHEAD del nodo testa, ossia l'indirizzo del nodo seguente...
        mv s2,t1 #...che diventer? il nuovo nodo HEAD, quindi aggiorno HEAD_PTR
        addi s4,s4,-1 #e decremento il counter dei nodi

        beqz s2, empty_list_update_lastptr #ovviamente se la lista ? vuota, devo aggiornare anche LAST_PTR
        j check_head_deletion #controlla se anche la nuova testa deve essere eliminata



    empty_list_update_lastptr:

        li s3,0 #metto a null il LAST_PTR
        j end_DEL # se sono qui, allora non hai altri nodi da eliminare, termina

    del_find_next:
        mv t2,s2 #prosegui a partire dalla testa

    del_find_loop:
        addi t3,t2,1 # allinea al PAHEAD
        lw t3,0(t3) #carica il puntatore al nodo successivo
        beqz t3,end_DEL #e se non ce n'? uno termina

        lb t4,0(t3) #carica il carattere (DATA) del nodo successivo
        bne t4,a0,del_go_next # se il carattere non coincide, vai avanti

        addi t5,t3,1 #allinea al PAHEAD del successivo  
        lw t5, 0(t5) #carica l'indirizzo (tramite PAHEAD) del nodo successivo

        addi t6,t2,1 #allinea al PAHEAD del nodo corrente
        sw t5, 0(t6) #e scrivilo all'interno del PAHEAD nodo corrente

        beq t3,s3,update_last_ptr #se il nodo ? l'ultimo aggiorna il LAST_PTR

        addi s4,s4,-1 #decrementa il contatore 
        j del_find_loop


    update_last_ptr:
        mv s3,t2 #aggiorna LAST_PTR con l'ultimo indirizzo
        addi s4,s4,-1 #decrementa il contatore
        j del_find_loop


    del_go_next:
        mv t2,t3 #vado avanti
        j del_find_loop


    end_DEL:
        lw ra,0(sp)
        addi sp,sp,4
        ret
    

SORT:

    addi sp,sp,-4
    sw ra,0(sp)
    
    li t0,1 #Numero nodi
    beq s4,zero, end_sort #se non ci sono nodi, termina
    mv t0,s4 #t0, indice che decrementer? contiene il numero dei nodi n


    first_sort_loop:
        beqz t0,end_sort #se ho completato i passaggi, termino

        mv t1,s2  #parto dalla HEAD
        li t2,0 # e metto il flag di scambio a zerro

        second_sort_loop:
            addi t3,t1,1 #Allineo al PAHEAD
            lw t4, 0(t3) #ptr al successivo
            beqz t4,check_if_swap_happened # se non c'? successivo, cio? sei alla fine, controlla se sono avvenuti scambi

            lb t5, 0(t1) # DATA corrente
            lb t6, 0(t4) # DATA successivo

            addi sp,sp,-8 #salvo i registri temporanei prima della chiamata
            sw t1,0(sp)
            sb t6,4(sp) 
            sb t5,5(sp) 
            sb t0,6(sp)
            
            #t5 - > categoria primo char
            mv a0,t5
            jal get_category
            mv t5,a0 

            #t6 -> categoria secondo char
            mv a0,t6
            jal get_category
            mv t6,a0    


            #ricarico i contenuti originali
            lb t0,6(sp)
            lw t1,0(sp)

            #ORDINAMENTO CRESCENTE: 
            # siccome devo avere cat0<cat1<cat2<cat3 
            # se cat(precedente)>cat(successivo) ==> swap
            bgt t5,t6, sort_do_swap
            blt t5,t6, sort_do_not_swap

            #altrimenti, se sono uguali, confronta gli ASCII code originali, recuperati dalla stack
            lb t5,5(sp) 
            lb t6,4(sp)
            bgt t5,t6,sort_do_swap # se cat(c1)>cat(c2) scambio
            j sort_do_not_swap

        sort_do_swap:

            #scambio i 2 caratteri fra di loro, non ha senso scambiare i puntatori in questa fase

            #ricarico gli ASCII codes originali, ma sono gi? nello stack
            lb t5, 5(sp) 
            lb t6, 4(sp)
            
            #effettuo lo scambio
            sb t5,0(t4)
            sb t6,0(t1) 
            # ho cambiato t1 durante get_category
            li t2,1 #swapMade = true

            addi sp,sp,8 #Ripristina lo stack
            mv t1,t4 #passo al successivo
            j second_sort_loop
                

        sort_do_not_swap:
            addi sp,sp,8 #Non scambio, ripristino la stack per iterazioni successive
            mv t1,t4 #passo al successivo
            j second_sort_loop # continuo


        check_if_swap_happened:
            beqz t2, end_sort # se non ho effettuato scambi, allora termino
            addi t0,t0,-1 # decremento il contatore n degli scambi da effettuare
            j first_sort_loop


    end_sort:

        lw ra,0(sp)
        addi sp,sp,4 #ripristino stack
        ret


get_category:
    # parametro in a0, mi restituisce in a0 un intero per la categoria
    # 3 -> MAIUSCOLO 
    # 2 -> minuscolo
    # 1 -> numero
    # 0 -> carattere speciale
    # -1 -> carattere non valido
    
    addi sp,sp,-4
    sw ra, 0(sp) #salvo il valore di ra

    #controlla se il carattere ? ammissibile ( 32 <= a0 <= 125)
    li t0,32
    blt a0,t0,char_not_valid 
    li t0,125
    bgt a0,t0,char_not_valid


    #Controllo se la lettera ? maiuscola (ASCII tra 65-90)
    li t0,65 # 'A'
    li t1,90 # 'Z'
    blt a0,t0, check_lowercase #lettera minore di 'A'
    ble a0,t1, is_uppercase #lettera minore o uguale a 'Z', quindi maiuscola




    check_lowercase:
        #Controllo se 97<x<122
        li t0,97 # 'a'
        li t1,122 # 'z'
        blt a0,t0,check_number # lettera minore di 'a'
        ble a0,t1, is_lowercase

    check_number:
        #Controllo se 48<x<57
        li t0,48 # '0'
        li t1,57 # '9'
        blt a0,t0,is_special #allora vuol dire che ? per forza speciale 
        ble a0,t1, is_number 
        j is_special


    is_uppercase:
        li a0, 3  # categoria 3 per maiuscole
        j return_category

    is_lowercase:
        li a0, 2  # categoria 2 per minuscole
        j return_category

    is_number:
        li a0, 1  # categoria 1 per numeri
        j return_category

    is_special:
        li a0, 0  # categoria 0 per caratteri speciali
        j return_category

    char_not_valid:
        li a0,-1  #se il carattere non ? valido restituisci -1

    return_category:
        lw ra,0(sp)
        addi sp,sp,4
        ret
        


find_next_free_addr: #ritorno in a1
    li t0,5 #devo trovare 5 byte

    check_bytes:
        lb t1,0(s5) #leggo il byte corrente
        bnez t1,reset_counter # se non trovo zero vuol dire che non c'? spazio
        
        addi t0,t0,-1 #decremento il contatore di ciclo (4 byte da analizzare, 3 byte da analizzare) 
        beqz t0,found

        addi s5,s5,1 # vado nel byte successivo
        j check_bytes #ricontrollo
        
        
        reset_counter:
            addi s5,s5,1 #analizzo a partire dal bit successivo
            li t0,5
            j find_next_free_addr #continua finche non trovi 5 byte liberi
        
        found:
            addi s5,s5,-4 # siccome sono andato avanti di 4 byte, vado indietro e ritorno
            mv a1,s5
            addi s5,s5,5 #siccome ora 5 byte sono occupati, faccio un grande balzo in avanti
            
            addi sp,sp,-4
            sw a0,0(sp) #salvo  a0 nello stack
            
            lw a0,0(sp)
            addi sp,sp,4 # ripristino la stack
            
            ret

