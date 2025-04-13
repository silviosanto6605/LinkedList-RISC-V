.data

listInput: .string 'ciaoprova123'
NEXT_FREE_ADDR: .word 0x10000000 #indirizzo di inizio dei dati statici


.text

la s1,listInput #salvo la testa della stringa di input che passera alla funzione di parsing
li s2,0 #HEAD_PTR puntatore alla testa della lista
li s3,0 #LAST_PTR puntatore all'ultimo elemento della lista

li s4,0 #counter dei nodi
la s5,NEXT_FREE_ADDR #carico NEXT_FREE_ADDR
# jal PARSING  #devo implementare la logica di parsing

li a0, 101
jal ADD           # Primo nodo
li a0, 102
jal ADD           # Secondo nodo
li a0, 103
jal ADD           # Terzo nodo




ADD: #parametro a0                             

 #chiamata alla funzione individua prox indirizzo
 # da gestire lo stack
 
jal find_next_free_addr  #ritorna in a1 il prossimo indirizzo di scrittura
 
 
sb a0,0(a1) #scrivo il dato,parametro dì ADD, nel campo DATA del nodo
sw zero,1(a1) #rendo null il puntatore del nodo inserito

beq zero,s4,firstADD  #e' il primo nodo? NO: proseguo, SÌ: salto

sw a1,1(s3) #salvo in PAHEAD del nodo prima l'indirizzo dell'ultimo
add s3,zero,a1 #salvo in LAST_PTR l'indirizzo dell'ultimo nodo
addi s4,s4,1 # aumento counter nodi
jr ra





 #caso in cui il nodo aggiunto sia il primo
 firstADD:
     add s2,zero,a1 #HEAD_PTR = indirizzo ultimo nodo
     add s3,zero,a1 #LAST_PTR = indirizzo ultimo nodo
     addi s4,s4,1 # aumento counter nodi
     jr ra
     
 

        
find_next_free_addr:
    lb t1,0(s5) #byte di DATA
    lw t2,1(s5) #4B di PAHEAD
    
    or t3,t1,t2 #Sono tutti 0? cioé: è libero?
    bne t3,zero,no_space #se no aumenta
    mv a1,s5
    ret
    
    no_space:
        addi s5,s5,1 #analizzo a partire dal bit successivo
        j find_next_free_addr #continua finche non trovi 5 byte liberi
    
 
        
         
    
        
    

