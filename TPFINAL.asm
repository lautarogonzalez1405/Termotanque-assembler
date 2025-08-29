;---------------------------------------
;TP FINAL - EJERCICIO 2 - PUNTO 1
;PROGRAMA PARA ENCENDER 4 LEDS
;---------------------------------------

#include <P16F628A.INC>


	LIST P=16F628A
		
;--------- DEFINICION DE LEDS -----------
LED0 EQU 0
LED1 EQU 1
LED2 EQU 2
LED3 EQU 3
;---------------------------------------

		ORG 0

INICIO
	bsf 	STATUS, RP0		;SELECCIONO BANCO 1
	clrf	TRISB			;CARGO EL TRISB CON 0
	
	bcf		TRISB, 0		;
	bcf		TRISB, 1		;CONFIGURO LOS RB0 AL RB3 COMO SALIDA
	bcf		TRISB, 2		;
	bcf		TRISB, 3		;
	
	bcf		STATUS, RP0		;SELECCIONO EL BANCO 0
	
	bsf		PORTB, LED0		;
	bsf		PORTB, LED1		;SE ENCIENDEN LOS 4 LEDS
	bsf		PORTB, LED2		;
	bsf		PORTB, LED3		;
	goto	$

	END