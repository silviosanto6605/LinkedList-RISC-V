.data

listInput: .string "ciaoprova123"


.text

la s1,listInput #salvo la testa della stringa di input che passera alla funzione di parsing
li s2,0 #HEAD_PTR puntatore alla testa della lista
li s3,0 #LAST_PTR puntatore all'ultimo elemento della lista
li s4,0 #counter dei nodi
li s5,0x10000000 #carico NEXT_FREE_ADDR, indirizzo di inizio dei dati statici
# jal PARSING  #devo implementare la logica di parsing


li a0,83 #S
jal ADD

li a0,105 #i
jal ADD

li a0,108 #l
jal ADD

li a0,118 #v
jal ADD

li a0,105 #i
jal ADD

li a0,111 #o
jal ADD


li t4,5

loop_test:
    beqz t4,end
    
    li a0,111 #o
    jal ADD
    addi t4,t4,-1
    j loop_test
    

end:
    jal PRINT
    li a7,10
    ecall



PRINT:

    beqz s2,end_print
    
    addi sp,sp,-4 #salvo ra
    sw ra, 0(sp)

    mv a0,s2 #passo come parametro s2, cioé la HEAD 
    jal print_recursive

    lw ra,0(sp) 
    addi sp,sp,4 #ripristino il ra

    
    end_print:
        li a0,10
        li a7,11
        ecall
        ret
    
    print_recursive:
        beqz a0, return_recursive_print #Base: se la HEAD è zero, vuol dire che non c'è un nodo
        
        addi sp,sp,-8 #devo salvare ra e a0, che contiene il puntatore al nodo attuale
        sw ra,0(sp)
        sw a0,4(sp)

        lb a0,0(a0) # carico e stampo il carattere del nodo corrente, puntato da a0
        li a7,11
        ecall

        li a0,44 #stampo un separatore
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

    beq zero,s4,firstADD       # Se è il primo nodo, salta
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



        
find_next_free_addr: #ritorno in a1
    li t0,5 #devo trovare 5 byte

check_bytes:
    lb t1,0(s5) #leggo il byte corrente
    bnez t1,reset_counter # se non trovo zero vuol dire che non c'è spazio
    
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
        
        
        # mv a0,a1 #DEBUG: MOSTRA INDIRIZZO
        # li a7,34
        # ecall
        
        # li a0,10 #stampo un ritorno di linea
        # li a7,11
        # ecall
        
        lw a0,0(sp)
        addi sp,sp,4 # ripristino la stack
        
        ret







