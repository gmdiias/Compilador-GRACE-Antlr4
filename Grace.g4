grammar Grace;

@header {

}

@members {
	
}

grace: decVar+ cmdIf+ decVar?;

// --------- TODO DECLARACAO DE VARIAVEL ------------ //

programa: dec
		  (dec)*;
		  
dec: decVar | decSub | cmdAtrib;
		  
decVar :
    VAR
    listaSpecVar
    DOISPONTOS
    tiposPrimitivos
    PONTOVIRGULA
    ;
      
listaSpecVar :
	specVar
	(VIRGULA specVar)*
	;     
	   
specVar:
    specVarSimples|
    specVarSimplesIni |
    specVarArranjo |
    specVarArranjoIni
    ;

specVarSimples //returns [String iden = $IDENTIFICADOR.text]:
	:IDENTIFICADOR
    ;

specVarSimplesIni:      
    IDENTIFICADOR
    RECEBE
    decExpressao
    ;
            
specVarArranjo:
	IDENTIFICADOR
	COLCHETEESQUERDO
	NUMERO
	COLCHETEDIREITO;	
	
specVarArranjoIni: 
	IDENTIFICADOR
	COLCHETEESQUERDO
	NUMERO
	COLCHETEDIREITO
	RECEBE
	CHAVEESQUERDO
	NUMERO(VIRGULA NUMERO)*
	CHAVEDIREITO
	;
	
// --- USO DE VARIAVEL ---
variavel: 
	IDENTIFICADOR |
	IDENTIFICADOR
	COLCHETEESQUERDO
	decExpressao
	COLCHETEDIREITO
	;


// ----- DECLARACAO DE SUBPROGRAMAS -----

decSub:
	decProc
	| decFunc
	;
      
// DECLARACAO DE PROCEDIMENTO      
decProc: 
	DEF
	IDENTIFICADOR
	PARENTEESQUERDO
	listaParametros
	PARENTEDIREITO
	bloco
	;

// DECLARACAO DE FUNCAO 
decFunc:
	DEF
	IDENTIFICADOR
	PARENTEESQUERDO
	listaParametros
	PARENTEDIREITO
	DOISPONTOS
	tiposPrimitivos
	bloco
	;
	
cmdChamadaProc:
	IDENTIFICADOR
	PARENTEESQUERDO
	decExpressao
	(VIRGULA decExpressao)*
	PONTOVIRGULA
;

// DECLARACAO DE BLOCO
bloco:
	CHAVEESQUERDO
	(dec)*
	(comando)*
	CHAVEDIREITO
	;

// DECLARACAO DE LISTA DE PARAMETROS
listaParametros:
	specParams?
	(PONTOVIRGULA specParams)*
	;
	
specParams:
	param
	(VIRGULA param)*
	DOISPONTOS
    tiposPrimitivos
    ;	
	
param: 
	IDENTIFICADOR
	| IDENTIFICADOR
		COLCHETEESQUERDO
		COLCHETEDIREITO
	; 


// TODO DECLARACAO ANINHADA DE SUBPROGRAMAS

// ----- DECLARACAO DE COMANDOS -----

comando:
	cmdSimples |
	bloco;
	
cmdSimples:
	cmdAtrib 
	|cmdRead
	|cmdWrite 
	|cmdIf
	|cmdFor
	|cmdWhile
	
	;

cmdAtrib:
	atrib
	PONTOVIRGULA
	;
	
atrib:
	IDENTIFICADOR
	( 	RECEBE|
		ATRIBUICAOSOMA |
		ATRIBUICAOSUBTRACAO |
		ATRIBUICAOMULTIPLICACAO |
		ATRIBUICAODIVISAO |
		ATRIBUICAORESTODIVISAO )
	decExpressao
	;

cmdRead:
	READ
	variavel
	PONTOVIRGULA
	;

cmdWrite:
	WRITE
	variavel
	;

cadeiaExpressaoLogica:
	(decExpressaoIgualdade|decExpressaoLogica|decExpressaoRelacional)+
	(operadorLogica cadeiaExpressaoLogica)*;
	
		
// ----- CONDICIONAL IF -----
cmdIf: 
	IDIF
	PARENTEESQUERDO
	(cadeiaExpressaoLogica)
	PARENTEDIREITO
	comando
	cmdElse
	;
	
cmdElse: 
	(IDELSE comando)?
;

// ---- CLA�O WHILE -----
cmdWhile: 
	IDWHILE
	PARENTEESQUERDO
	cadeiaExpressaoLogica
	PARENTEDIREITO
	comando
;
	
// ----- LA�O FOR -----
cmdFor: 
	IDFOR
	PARENTEESQUERDO
	atrib
	PONTOVIRGULA
	(decExpressaoRelacional | decExpressaoIgualdade | decExpressaoLogica)+
	PONTOVIRGULA
	atribPasso
	PARENTEDIREITO
	comando
;

atribPasso:
	specVarSimples
	operador
	valor
	;

// --- Interrup��o do La�o
cmdStop:
	IDSTOP
	PONTOVIRGULA
;

// -- Salto de Intera��o
cmdSkip:
	IDSKIP
	PONTOVIRGULA
;
	
// ----- DECLARACAO DE EXPRESSAO -----
decExpressao: 
	decExpressao operador decExpressao
//	|decExpressao '?' decExpressao ':' decExpressao
    |valor
    ;
	  
valor: IDENTIFICADOR
	 | (NUMERO|STRING|BOOLEAN)
     | PARENTEESQUERDO decExpressao PARENTEDIREITO
     ;

operador:
	 SOMA
	|SUBTRACAO
	|MULTIPLICACAO
	|DIVISAO
	|RECEBE
	|ATRIBUICAOSOMA 
	|ATRIBUICAOSUBTRACAO 
	|ATRIBUICAOMULTIPLICACAO 
	|ATRIBUICAODIVISAO 
	|ATRIBUICAORESTODIVISAO
	;

// ----- DECLARACAO DE EXPRESSAO RELACIONAL-----
decExpressaoRelacional:
	 decExpressaoRelacional operadorRelacional decExpressaoRelacional
	 |valorRelacional;

valorRelacional:
	  IDENTIFICADOR
	  |NUMERO
	  |decExpressao ;
	  
operadorRelacional:
	MAIOR
	|MAIORIGUAL
	|MENOR
	|MENORIGUAL;

// ----- DECLARACAO DE EXPRESSAO IGUALDADE-----
decExpressaoIgualdade:
	 decExpressaoIgualdade operadorIgualdade decExpressaoIgualdade
	 |valorIgualdade;

valorIgualdade:
	  IDENTIFICADOR
	  |(NUMERO|STRING|BOOLEAN)
	  |PARENTEESQUERDO decExpressaoIgualdade PARENTEDIREITO;
	  
operadorIgualdade:
	COMPARA
	|DIFERENTE;

// ----- DECLARACAO DE EXPRESSAO LOGICA-----
decExpressaoLogica:
	 decExpressaoLogica operadorLogica decExpressaoLogica
	 |valorLogica;

valorLogica:
	  IDENTIFICADOR
	  |BOOLEAN
	  |PARENTEESQUERDO decExpressaoLogica PARENTEDIREITO;
	  
operadorLogica:
	OULOGICO
	|ELOGICO ;	
// ----- DECLARACAO DE COMENTARIOS -----
LineComment : 
	COMENTARIO ~[\r\n]* -> skip;
	
// ----- DECLARACAO DE TIPOS -----
      
tiposPrimitivos : decInt | TIPOBOOL | decString;
	
tipoNumero : 
	NUMERO;

tipoArranjo :
    CHAVEESQUERDO
	NUMERO
	(VIRGULA NUMERO)*
	CHAVEDIREITO
	;
			
decInt : 
	TIPOINT |
	TIPOINT
	COLCHETEESQUERDO
	NUMERO
	COLCHETEDIREITO
	;
		
decString :
 	TIPOSTRING |
	TIPOSTRING 
	COLCHETEESQUERDO
	NUMERO
	COLCHETEDIREITO
	;
			
// ---------TODO DECLARACAO DE VARIAVE FIM------------ //
	
// TOKENS
BOOLEAN : 
	TRUE 
	| FALSE
	;
	
TIPOINT : 'int';
TIPOSTRING : 'string';
PARENTEESQUERDO : '(';
PARENTEDIREITO : ')';
COLCHETEESQUERDO : '[';
COLCHETEDIREITO : ']';
CHAVEESQUERDO : '{';
CHAVEDIREITO : '}';
VIRGULA : ',';
PONTOVIRGULA : ';';
SOMA : '+';
SUBTRACAO : '-';
MULTIPLICACAO : '*';
DIVISAO : '/';
RESTODIVISAO : '%';
COMPARA : '==';
DIFERENTE : '!=';
MAIOR : '>';
MAIORIGUAL : '>=';
MENOR : '<';
MENORIGUAL : '<=';
OULOGICO : '||';
ELOGICO : '&&';
NEGACAO : '!';
RECEBE : '=';
ATRIBUICAOSOMA : '+=';
ATRIBUICAOSUBTRACAO : '-=';
ATRIBUICAOMULTIPLICACAO : '*=';
ATRIBUICAODIVISAO : '/=';
ATRIBUICAORESTODIVISAO : '%=';
INTERROGACAO : '?';
DOISPONTOS : ':';   
COMENTARIO : '//';
TRUE : 'true';
FALSE : 'false';
TIPOBOOL : 'bool';
IDSTOP: 'stop';
IDSKIP: 'skip';
IDIF: 'if';
IDELSE: 'else';
IDWHILE: 'while';
IDFOR: 'for';

WRITE : 'write';
READ : 'read';
DEF : 'def';
VAR : 'var';
PROGRAMA : 'programa';
END : 'end';

IDENTIFICADOR : [a-zA-Z_][a-zA-Z0-9_]* ;
NUMERO : [0-9]*;
STRING : STRINGPARTICAO '"';
STRINGPARTICAO : '"' (~["\\\r\n] | '\\' (. | EOF))*;
WS : [ \t\r\n]+ -> skip ; // skip spaces, tabs, newlines
