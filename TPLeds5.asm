;****************************************************************************************
; TP FINAL - EJERCICIO 2 - PUNTO 5
; PROGRAMA QUE ENCIENDE 4 LEDS CON UNA DEMORA DE 500ms ENTRE ELLOS
; Y LUEGO LOS APAGA CON LA MISMA DEMORA
; ESTE PROGRAMA ES IDENTICO AL USADO EN EL PUNTO 4, SE AGREGA AL FINAL
; LAS SUBRUTINAS NECESARIAS PARA GENERAR EL APAGADO DE LEDS UNO POR UNO CON EL RETARDO
;****************************************************************************************


	#include <p16f628a.inc>

Delay1 EQU 0x20 ; Definimos 3 registros que usaremos
Delay2 EQU 0x21 ; en los retardos Delay1, Delay2 y Delay3
Delay3 EQU 0x22 ;

Led1 EQU 0		;
Led2 EQU 1		;
Led3 EQU 2		;Definimos los 4 leds a encender y apagar
Led4 EQU 3		;
     
	org 0	    ; Iniciar el Programa en la dirección 0 de la memoria de programa
Inicio:
     bsf       STATUS,RP0     ; Selecciono el banco 1
     clrf      TRISB          ; Definimos trisb como salida
     bcf       STATUS,RP0     ; De vuelta al banco 0
	 goto	   RutinaConfig	  ; Nos dirigimos a RutinaConfig para saltarnos el retardo

RetardoMedioSeg:
	decfsz    Delay1,f        	; Decremento Delay1 hasta llegar a cero
    goto      RetardoMedioSeg   ; Cada loop toma 3 ciclos de maquina * 127 loops= 381 instrucciones
	movlw	  d'127'		  
	movwf	  Delay1		  	; Se vuelve a cargar Delay1 con 127
	decfsz    Delay2,f        	; Delay2 decrementara su valor en 1 cada vez que Delay1 llegue a 0
	goto      RetardoMedioSeg   ;
	movlw	  d'186'
	movwf	  Delay2		  	; Se vuelve a cargar Delay2 con 186
	decfsz	  Delay3,f		  	;	Idem linea 41
	goto	  RetardoMedioSeg   ;	{[(3*127+1)*186+3*186+1]*7+3*7+1} * 1uS = 501.299uS (Medio segundo aprox)
	movlw	  d'7'
	movwf	  Delay3
	return

RutinaConfig:
	movlw	   d'127'		  	;
	movwf	   Delay1		  	;
	movlw	   d'186'		  	;
	movwf	   Delay2		  	; Rutina de inicio donde los registros Delay se cargan con los valores
	movlw	   d'7'			  	; para generar el retardo deseado
	movwf	   Delay3		  	;

RutinaLeds:
	bsf		   PORTB,Led1 	  	; Encendemos el primer led
	call	   RetardoMedioSeg	; Llamamos a la subrutina del retardo
	bsf		   PORTB,Led2		; Repetimos el proceso hasta encender todos los leds
	call	   RetardoMedioSeg
	bsf		   PORTB,Led3
	call	   RetardoMedioSeg
	bsf		   PORTB,Led4
	call	   RetardoMedioSeg	; Generamos un retardo despues de prender el ultimo led
	bcf		   PORTB,Led4		; y lo apagamos
	call	   RetardoMedioSeg	; Repetimos el proceso hasta apagar todos los leds
	bcf		   PORTB,Led3
	call	   RetardoMedioSeg
	bcf		   PORTB,Led2
	call	   RetardoMedioSeg
	bcf		   PORTB,Led1
	call	   RetardoMedioSeg
	goto 	   RutinaLeds		; Volvemos a empezar
	
	end