%{

  /* Simple Lexer and Parser for SmallC Language Using Yacc and Lex */

void yyerror (char *s);

int yylex();

 /* C declarations THAT ARE used in actions */
#include <stdio.h>    
#include <stdlib.h>
#include <ctype.h>
#include <string.h>


void newIntegerVariable(char* varname);

void newCharacterVariable(char* varname);

int isDeclaredBefore(char* varname);

int ValueOfIntegerVariable(char* varname);

char ValueOfCharacterVariable(char* varname);

int isValidVariable(char* varname);

void UpdateIntegerVariable(char* varname, int newValue);

void UpdateCharacterVariable(char* varname, char newValue);

void PrintLinkedList();


// TABLE FOR INT VARIABLES
struct intNode
{
	char* variableName;
	int value;
	struct intNode* Next;
};
typedef struct intNode intNode;

intNode* headIntegerTable = NULL;

// TABLE FOR CHARACTER VARIABLES
struct charNode
{
	char* variableName;
	char value;
	struct charNode* Next;

};
typedef struct charNode charNode;

charNode* headCharacterTable = NULL;


%}

%union {int num; char* id; char karakter; char* text;}         /* Yacc definitions */

%start line

%token print
%token printchar
%token exit_command
%token CL
%token CR
%token WHILE
%token IF
%token THEN
%token ELSE
%token COLON
%token SEMICOL
%token MINUS
%token PLUS
%token MULT
%token MODUL
%token ISEQ
%token ISNOTEQ
%token EQ
%token GRE
%token GREOREQ
%token SMAL
%token SMALOREQ
%token PL
%token PR
%token INT
%token CHAR
%token <num> number
%token <id> identifier
%token <karakter> character 

%type <num> line exp term if_statement decleration while_statement initialization
%type <id> assignment
%type <karakter> article

%%

/* descriptions of expected inputs BNF          corresponding actions (in C) */

line    :  decleration SEMICOL
		| line decleration SEMICOL	{;}
		| initialization SEMICOL	{;}
		| line initialization SEMICOL	{;}
		|assignment SEMICOL		{;}
		| exit_command   		{exit(EXIT_SUCCESS);}
		| print exp SEMICOL		{printf(">> %d\n", $2);}
		| printchar article SEMICOL  {printf(">> %c\n", $2);}
		| line printchar article SEMICOL  {printf(">> %c\n", $3);}
		| line print exp SEMICOL	{printf(">> %d\n", $3);}
		| line assignment SEMICOL	{;}
		| line exit_command      	{exit(EXIT_SUCCESS);}
		| if_statement SEMICOL          	 {printf(">> if well-formed\n"); if ($1) printf(">> Condition is true.\n"); else printf(">> Condition is false.\n");}
		| line if_statement SEMICOL              {printf(">> if well-formed\n"); if ($2) printf(">> Condition is true.\n"); else printf(">> Condition is false.\n");}
		| while_statement SEMICOL	{printf(">> while well-formed\n"); if ($1) printf(">> Condition is true.\n"); else printf(">> Condition is false.\n");}
		| line while_statement SEMICOL {printf(">> while well-formed\n"); if ($2) printf(">> Condition is true.\n"); else printf(">> Condition is false.\n");}
		
        ;



decleration : CHAR identifier {$$ = 1 ; newCharacterVariable($2);}
	    | INT identifier {$$ = 1 ; newIntegerVariable($2);}
	;

assignment : identifier EQ exp  { UpdateIntegerVariable($1,$3); }
	   | identifier EQ character {UpdateCharacterVariable($1, $3);}
	;

initialization: INT identifier EQ exp {$$ = 1 ; newIntegerVariable($2); UpdateIntegerVariable($2,$4); }
		| CHAR identifier EQ character {$$ = 1 ; newCharacterVariable($2); UpdateCharacterVariable($2,$4);}
		;



if_statement : IF PL exp PR  CL line CR                    {$$ = $3;}
	     | IF PL exp PR  CL line CR ELSE CL line CR    {$$ = $3;}
;

while_statement : WHILE PL exp PR  CL line CR           {$$ = $3;}

exp    	: term                  {$$ = $1;}
       	| exp PLUS term          {$$ = $1 + $3;}
       	| exp MINUS term          {$$ = $1 - $3;}
	| exp MULT term          {$$ = $1 * $3;}
	| exp MODUL term          {$$ = $1 % $3;}
	| exp ISEQ term          {$$ = $1 == $3; }
	| exp ISNOTEQ term          {$$ = $1 != $3; }
	| exp GRE term          {$$ = $1 > $3;}
	| exp GREOREQ term          {$$ = $1 >= $3; }
	| exp SMAL term          {$$ = $1 < $3;}	
	| exp SMALOREQ term          {$$ = $1 <= $3; }
       	;


term   	: number               {$$ = $1;}
	| identifier	       {$$ = ValueOfIntegerVariable($1);} 
        ;


article : character 	 	{$$ = $1;}
	| identifier	       {$$ = ValueOfCharacterVariable($1);} 
        ;





%%                     

/* C DEFINITIONS */


void newIntegerVariable(char* varname){

	int data = 0;
	
	// we do not want REDECLERATION 

	if (isDeclaredBefore(varname) == 1){
		// RE-DECLERATION OF THE VARIABLE
		yyerror ("Error: Re-declaration of a variable!");
		return;
		
	}
	else{
		// this means it has not declared before
		// this is the first time

		intNode* newInteger = (intNode*) malloc(sizeof(intNode));
		newInteger->variableName = varname;
		newInteger->value = data;
		newInteger->Next = NULL;
		
		if (headIntegerTable == NULL){
			headIntegerTable = newInteger;
			
			return;
				
		}
		else{
		
		// find the tail of the linked list
		intNode* iterator = headIntegerTable;
		while(iterator->Next != NULL){
			// go to the last one 
			iterator = iterator->Next;
		}

		//iterator is the last element 
		
		iterator->Next = newInteger;

		
		
		return;
		}
	}
}


void newCharacterVariable(char* varname){

	char data = '\0';
	
	// we do not want REDECLERATION 

	if (isDeclaredBefore(varname) == 1){
		// RE-DECLERATION OF THE VARIABLE
		yyerror ("Error: Re-declaration of a variable!");
		return;
		
	}
	else{
		// this means it has not declared before
		// this is the first time

		charNode* newChar = (charNode*) malloc(sizeof(charNode));
		newChar->variableName = varname;
		newChar->value = data;
		newChar->Next = NULL;
		
		if (headCharacterTable == NULL){
			headCharacterTable = newChar;
			
			return;
				
		}
		else{
		
		// find the tail of the linked list
		charNode* iterator = headCharacterTable;
		while(iterator->Next != NULL){
			// go to the last one 
			iterator = iterator->Next;
		}

		//iterator is the last element 
		
		iterator->Next = newChar;

		
		
		return;
		}
	}
}




int isDeclaredBefore(char* varname){

	intNode* iteratorInt = headIntegerTable;

	while(iteratorInt != NULL){
		// if they are the same variable
		if (!strcmp(varname, iteratorInt->variableName)){
			return 1;
			// it has declared before
		}
		else 
			iteratorInt = iteratorInt->Next;;
	}


	charNode* iteratorChar = headCharacterTable;

	while(iteratorChar != NULL){
		// if they are the same variable
		if (!strcmp(varname, iteratorChar->variableName)){
			return 1;
			// it has declared before
		}
		else 
			iteratorChar = iteratorChar->Next;;
	}



	return 0;
	// it has not been declared before
	
}


void UpdateIntegerVariable(char* varname, int newValue){
	
	if (isValidVariable(varname)){
		// if it is a valid variable
		
		// find it and then change it 

		intNode* iteratorInt = headIntegerTable;

		while(iteratorInt != NULL){
		
			if (!strcmp(varname, iteratorInt->variableName)){
			// we found it 
				iteratorInt->value = newValue;
				return;
			}
			else 
				iteratorInt = iteratorInt->Next;
		}
			
	}

	
	
}


void UpdateCharacterVariable(char* varname, char newValue){
	
	if (isValidVariable(varname)){
		// if it is a valid variable
		
		// find it and then change it 

		charNode* iteratorChar = headCharacterTable;

		while(iteratorChar != NULL){
		
			if (!strcmp(varname, iteratorChar->variableName)){
			// we found it 
				iteratorChar->value = newValue;
				return;
			}
			else 
				iteratorChar = iteratorChar->Next;
		}
			
	}

	
	
}



int isValidVariable(char* varname){
	/*
		there might not be such a variable 
		we have to check the validity of the variable before update
	*/

	
	intNode* iteratorInt = headIntegerTable;

	while(iteratorInt != NULL){
		// if they are the same variable
		if (!strcmp(varname, iteratorInt->variableName)){
			return 1;
			// it is VALID VARIABLE, we found it 
		}
		else 
			iteratorInt = iteratorInt->Next;
	}

	
	charNode* iteratorChar = headCharacterTable;

	while(iteratorChar != NULL){
		// if they are the same variable
		if (!strcmp(varname, iteratorChar->variableName)){
			return 1;
			// it is VALID VARIABLE, we found it 
		}
		else 
			iteratorChar = iteratorChar->Next;;
	}



	
	yyerror ("Error: NON-VALID variable.\nVariable does not exist!");
	return 0;
	// we could not find it, it is NOT VALID variable


}

int ValueOfIntegerVariable(char* varname){
	/*
		the value of a variable, hashing logic
	*/

	intNode* iteratorInt = headIntegerTable;

	while(iteratorInt != NULL){
		
		if (!strcmp(varname, iteratorInt->variableName)){
			// we found it 
			return iteratorInt->value ;
				
			}
			else 
				iteratorInt = iteratorInt->Next;
		}

	return 0;
		
}


char ValueOfCharacterVariable(char* varname){
	/*
		the value of a variable, hashing logic
	*/

	charNode* iteratorChar = headCharacterTable;

	while(iteratorChar != NULL){
		
		if (!strcmp(varname, iteratorChar->variableName)){
			// we found it 
			return iteratorChar->value ;
				
			}
			else 
				iteratorChar = iteratorChar->Next;
		}

	return 0;
		
}



void PrintLinkedList(){
	intNode* iteratorInt = headIntegerTable;
	printf("< ");
	while(iteratorInt != NULL){
	
		printf("%d ", iteratorInt->value);
		iteratorInt = iteratorInt->Next;
		
	}

	printf(" >\n");

	charNode* iteratorChar = headCharacterTable;
	printf("CHAR: < ");
	while(iteratorChar != NULL){
	
		printf("%c ", iteratorChar->value);
		iteratorChar = iteratorChar->Next;
		
	}

	printf(" >\n");

	
}


int main (void) {
	/* 	Invokes the lexical analyzer by calling the yylex subroutine. */

	/*
		yyparse() <-> yylex() 		
	*/
	

	return yyparse ( );
}

// DEFAULT ERROR FUNCTION
void yyerror (char *s) {fprintf (stderr, "%s\n", s);} 

