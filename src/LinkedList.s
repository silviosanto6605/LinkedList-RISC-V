.data

listInput: .string 'ciaoprova123'
HEAD_PTR: .word 0 #puntatore alla testa della lista
LAST_PTR: .word 0 #puntatore all'ultimo elemento della lista
BASE_ADDR: .word 0x10000000 #parto a salvare la lista da questo indirizzo




.text

la s1,listInput #salvo la testa della stringa di input che passerò alla funzione di parsing
lw s2,HEAD_PTR
lw s3,LAST_PTR
li s4,0 #counter dei nodi
# jal PARSING  #devo implementare la logica di parsing

li a0, 101
jal ADD           # Primo nodo
li a0, 102
jal ADD           # Secondo nodo
li a0, 103
jal ADD           # Terzo nodo





ADD: #ADD(a0->char)
    la t0, BASE_ADDR #carico l'indirizzo di BASE_ADDR
    lw t1, 0(t0) #contenuto di BASE_ADDR caricato in t1
    
    sb a0, 0(t1) #scrivo nel primo byte (cioé DATA) il carattere passato come parametro
    sw zero, 1(t1) #PAHEAD= 0x00000000 cioé zero
    
    bgt s4,zero,normal_ADD #tratto la prima ADD diversamente dalle altre
    
    mv s2,t1 #HEAD_PTR salvato nella variabile globale
    mv s3,t1 #LAST_PTR salvato nella variabile globale
    j updateADD
    
    normal_ADD:
        sw t1,1(s3) #Collego l'ultimo nodo a quello attuale (cioé )
        mv s3,t1 #aggiorno LAST_PTR
    
    updateADD:
        addi t1,t1,5 # aumento il BASE_ADDR di 5
        sw t1, 0(t0) #
        addi s4,s4,1 #ho aggiunto un nodo, incremento il contatore
        jr ra

     
    
        
    

