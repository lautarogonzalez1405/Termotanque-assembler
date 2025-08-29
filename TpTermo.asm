;*****************************************************************************
; TP FINAL - PUNTO 1
; PROGRAMA CONTROLAR TEMPERATURA TERMOTANQUE
;*****************************************************************************

#include <p16f628a.inc>

Delay1 EQU 0x20 ; 
Delay2 EQU 0x21 ; 3 registros utilizados para controlar retardos
Delay3 EQU 0x22 ;

LedBomba			EQU 0 ; 
LedTempAgua			EQU 1 ; Creamos 4 leds para controlar diferentes caracteristicas del termo
LedResistenciaOn	EQU 2 ; 
LedResistenciaOff	EQU 3 ; 
LedTermo			EQU 4 ;

TempMax		EQU	0x23 ; 
TempMin		EQU 0x24 ; 3 registros para controlar las temperaturas
TempAgua	EQU 0x25 ; 
Litros		EQU 0x26 ; Registro para controlar los litros del termo
LitrosMax	EQU 0x27 ; Registro que contiene el maximo de litros
LitrosMin	EQU	0x28 ; Registro que contiene el minimo de litros
		org 0
Inicio:
    bsf     STATUS,RP0  	; Selecciono el banco 1
    clrf    TRISB       	; Definimos trisb como salida
    bcf     STATUS,RP0  	; De vuelta al banco 0
	goto	RutinaConfig	; Nos dirigimos a la RutinaConfig para evitar el retardo

RetardoMedioSeg:					; Se genera un subrutina que genera un retardo de medio segundo 
	decfsz  Delay1,f        		; Decremento Delay1 hasta llegar a cero
    goto    RetardoMedioSeg   		; Cada loop toma 3 ciclos de maquina * 127 loops= 381 instrucciones
	movlw	d'127'		  
	movwf	Delay1		  			; Se vuelve a cargar Delay1 con 127
	decfsz  Delay2,f        		; Delay2 decrementara su valor en 1 cada vez que Delay1 llegue a 0
	goto    RetardoMedioSeg   	
	movlw	d'186'
	movwf	Delay2		  			; Se vuelve a cargar Delay2 con 186
	decfsz	Delay3,f	
	goto	RetardoMedioSeg
	movlw	d'7'
	movwf	Delay3		  			; Se vuelve a cargar Delay3 con 7
									; {[(3*127+1)*186+3*186+1]*7+3*7+1} * 1uS = 501.299uS (Medio segundo aprox)
	return

RutinaConfig:
	movlw	d'110'		; 
	movwf	LitrosMax	; 
	movlw	d'0'		; 
	movwf	Litros		;
	movlw	d'50'		;
	movwf	LitrosMin	;
	movlw	d'20'		; Hacemos la carga de todos los registros (LitrosMax, LitrosMin, Litros, TempMax, TempMin, y TempAgua)
	movwf	TempMin		;
	movlw	d'45'		;
	movwf	TempMax		;
	movlw	d'21'		;
	movwf	TempAgua	;
	movlw	d'127'		;	  
	movwf	Delay1		; 
	movlw	d'186'		; 
	movwf	Delay2		; Valores necesarios en los Delay para generar un retardo de medio segundo 
	movlw	d'7'		; 
	movwf	Delay3		; 
PrenderTermo:
	bsf		PORTB,LedTermo	; Prendemos el led que indica que el termo esta prendido

ChequeoAgua:
	movf	Litros, W		; Mueve el contenido de Litros a W
	subwf	LitrosMax, W	; Substrae W de LitrosMax y almacena el resultado en W
	btfsc	STATUS, Z		; Chequeo del bit Z del STATUS para saber el resultado de la resta
	goto	VerificarTemp	; Si la resta da 0 (Z = 1) salta a la rutina del chequeo de la temperatura
	call	Bomba			; Si la resta no da 0 (Z = 0) ejecuta la subrutina Bomba
	goto	ChequeoAgua		; Una vez que termina la subrutina bomba vuelve a chequear los litros

Bomba:						; Esta subrutina aumentara en 1, con cada aumento volvera a comparar los litros y se ejecutara
							; hasta alcanzar los 110 litros
	bsf		PORTB,LedBomba	; Prendemos el led que especifica la carga de agua
	incf	Litros, F		; Incrementamos el valor de Litros en 1
	return					; Vuelve a comparar la cantidad de litros

VerificarTemp:
	bcf		PORTB,LedBomba		; Apagamos el led de la carga de agua
	bsf		PORTB,LedTempAgua	; Prendemos el led de chequeo de temperatura
	movf	TempAgua, W			; Se mueve el contendio de TempAgua al registro W
	subwf	TempMax, W			; Se substrae TempMax del registro W
	btfsc	STATUS, Z			; Idem linea 49
	goto	AbrirCanilla		
	call	PrenderResistencia	
	goto	VerificarTemp

PrenderResistencia:
	bsf		PORTB,LedResistenciaOn	; Se prende el led que indica que la resistencia esta andando
	call	RetardoMedioSeg			; Llamamos al retardo
	bcf		PORTB,LedResistenciaOn	; Se apaga el led de la resistencia
	call	RetardoMedioSeg
									; Al igual que la bomba esta subrutina incrementa la temperatura hasta llegar a la temperatura maxima
	incf	TempAgua, f				; Se incrementa TempAgua en 1
	return							; Se vuelve a verificar la temperatura

AbrirCanilla:
	bcf		PORTB,LedTempAgua		; Apagamos el led de chequeo de temperatura
	bsf		PORTB,LedResistenciaOff	; Se prende el led que indica que se apago la resistencia (El agua ya llego a la temperatura maxima)
	movf	Litros, W
	subwf	LitrosMin, W
	btfsc	STATUS, Z
	goto	ApagarTermo
	decf	Litros, F				; Se reduce en 1 el registro Litros
	goto	AbrirCanilla


ApagarTermo:
	bcf		PORTB,LedResistenciaOff	; Apagamos el led que indica que se alcanzo la temp maxima
	bcf		PORTB,LedTermo			; Apagamos el led que indica que el termo esta prendido
	movlw	d'28'				
	movwf	Delay3					; Cargamos el Delay3 con 28 para que el retardo de medio segundo pase a ser uno de dos segundos
									; {[(3*127+1)*186+3*186+1]*28+3*28+1} * 1uS = 2.005.193uS (Dos segundos aprox)
	call	RetardoMedioSeg
	goto	RutinaConfig			; Volvemos a empezar

	end