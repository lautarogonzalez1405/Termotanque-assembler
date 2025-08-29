;*************************************************************************************************
;TP FINAL - EJERCICIO 2 - PUNTO 2
;PROGRAMA PARA ENCENDER Y APAGAR 4 LEDS CADA UN SEGUNDO
;*************************************************************************************************



#include <p16F628.inc>

Delay1 EQU 0x20; Definimos 3 registros que usaremos
Delay2 EQU 0x21; en los retardos Delay1, Delay2 y Delay3
Delay3 EQU 0x22;

Led1 EQU 0		;
Led2 EQU 1		;
Led3 EQU 2		;Definimos los 4 leds a encender y apagar
Led4 EQU 3		;
     
	org 0	  ; Iniciar el Programa en la dirección 0 de la memoria de programa
Inicio:
     bsf       STATUS,RP0     ; Selecciono el banco 1
     clrf      TRISB          ; Definimos trisb como salida
     bcf       STATUS,RP0     ; De vuelta al banco 0

RutinaConfig:
	movlw	   d'127'		  ;
	movwf	   Delay1		  ;
	movlw	   d'186'		  ; Rutina inicial donde los registros Delay se cargan con los valores
	movwf	   Delay2		  ; necesarios para generara el retardo deseado
	movlw	   d'14'		  ;
	movwf	   Delay3		  ;

LoopPrincipal:		  ; Loop para prender y apagar los leds
     bsf       PORTB,Led1     ; 
	 bsf	   PORTB,Led2	  ;
	 bsf	   PORTB,Led3	  ; Encendemos los 4 leds
	 bsf	   PORTB,Led4	  ;
LoopEncendido:		  ; Crear subrutina LoopEncendido
     decfsz    Delay1,f       ; Decremento Delay1 hasta llegar a cero
     goto      LoopEncendido  ; Cada loop toma 3 ciclos de maquina * 127 loops= 381 instrucciones
	 movlw	   d'127'		  
	 movwf	   Delay1		  ; Se vuelve a cargar Delay1 con 127
	 decfsz    Delay2,f       ; Delay2 decrementara su valor en 1 cada vez que Delay1 llegue a 0
	 goto      LoopEncendido  ;
	 movlw	   d'186'
	 movwf	   Delay2		  ; Se vuelve a cargar Delay2 con 186
	 decfsz	   Delay3,f		  ;	Idem linea 36
	 goto	   LoopEncendido  ;	{[(3*127+1)*186+3*186+1]*14+3*14+1} * 1uS = 1.002.597uS (Un segundo aprox)
	 movlw	   d'14'
	 movwf	   Delay3		  ; Se vuelve a cargar Delay3 con 14
	 bcf       PORTB,Led1     ; 
	 bcf	   PORTB,Led2	  ;
	 bcf	   PORTB,Led3	  ;	Apagamos los 4 leds
	 bcf	   PORTB,Led4     ;

LoopApagado:		  ; Crear subrutina LoopApagado
     decfsz    Delay1,f       ; hacemos el mismo retardo anterior
     goto      LoopApagado
     movlw	   d'127'
	 movwf	   Delay1
	 decfsz    Delay2,f
     goto      LoopApagado
	 movlw	   d'186'
	 movwf	   Delay2
	 decfsz	   Delay3,f
	 goto	   LoopApagado
     goto      RutinaConfig   ; y volvemos todo de nuevo...
     end
