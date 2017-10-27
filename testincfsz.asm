// SI EJECUTAMOS TAL Y COMO ESTA DEBERIA TIRAR UN 3 POR EL GOTO 9.
// SI AGREGAMOS UN TERCER INC LA CONDICION NO SE CUMPLE Y SALTA A 8, CON UN RESULTADO FINAL DE R[1]=6

A81 // 001010 1 0000001 -- INC 0x01 (Incrementa 0x01 en 1 y lo guarda en 0x01) REG[1]=1
A81 // 001010 1 0000001 -- INC 0x01 (Incrementa 0x01 en 1 y lo guarda en 0x01) REG[1]=2
b81 // 00101110000001   -- DECFSZ 0x01 (Decrementa 0x01 en 1 y lo guarda en 0x01/ Jump si el resultado es 0) REG[1] = 1
b81 // 00101110000001   -- DECFSZ 0x01 (Decrementa 0x01 en 1 y lo guarda en 0x01/ Jump si el resultado es 0) REG[1] = 0
2808    // 10 1 00000001000  -- GOTO 0x08 (SALTO HACIA POSICION 8)
2809    // 10 1 00000001000  -- GOTO 0x09 (SALTO HACIA POSICION 9)
A81 // 001010 1 0000001 -- INC 0x01 (Incrementa 0x01 en 1 y lo guarda en 0x01) 
A81 // 001010 1 0000001 -- INC 0x01 (Incrementa 0x01 en 1 y lo guarda en 0x01) 
A81 // 001010 1 0000001 -- INC 0x01 (Incrementa 0x01 en 1 y lo guarda en 0x01) 
A81 // 001010 1 0000001 -- INC 0x01 (Incrementa 0x01 en 1 y lo guarda en 0x01) 
A81 // ***JUMP  001010 1 0000001 -- INC 0x01 (Incrementa 0x01 en 1 y lo guarda en 0x01) REG[1]=8|REG[1]=4
A81 // 001010 1 0000001 -- INC 0x01 (Incrementa 0x01 en 1 y lo guarda en 0x01) REG[1]=9|REG[1]=5