%{
  /* Simple Lexer and Parser for SmallC Language Using Yacc and Lex */

#include "y.tab.h"

#include <string.h>

void yyerror (char *s);

int yylex();

char* copyString(char* from);

%}

%%

"if"				   {return IF;}
"print"				   {return print;}
"printchar"                        {return printchar;}
"exit"				   {return exit_command;}
"int"  				   {return INT;}
"char"  			   {return CHAR;}
"then"                             {return THEN;}
"else"                             {return ELSE;}
"while"                            {return WHILE;}
"/*".*"*/"                         {;} //comment 1
"//".*"\n"			    {;} //comment 2

"{"                     {return CL;}
"}"                     {return CR;}
"-" 			{return MINUS;}
"+" 			{return PLUS;}
"*" 			{return MULT;}
"%"  			{return MODUL;}
"=" 			{return EQ;}
"==" 		        {return ISEQ;} 
"!=" 		        {return ISNOTEQ;}
";" 			{return SEMICOL;}
":"                     {return COLON;}
">"                     {return GRE;}
">="                     {return GREOREQ;}
"<"                     {return SMAL;}
"<="                     {return SMALOREQ;}
"("  			{return PL;}
")"  			{return PR;}


"'"[a-zA-Z0-9]"'"     {yylval.karakter = yytext[1]; return character;} 

[a-zA-Z_][a-zA-Z0-9_]*      {yylval.id = copyString(yytext); return identifier;}

[0-9]+                      {yylval.num = atoi(yytext); return number;}

[ \t\n]                ;

.                      {ECHO; yyerror ("Invalid character");}

%%

/* Returns the value 1 when the end of input occurs. */
int yywrap (void) {return 1;}



char* copyString(char* from){
/*
	This function is the exact implementation of strdup() funciton in C
	It copies one string to another, while creating a dynamically allocated memory
*/
	
	int length = strlen(from);

	char* copied = NULL;

	copied = (char*) malloc( sizeof(char) * length + 1 );

	strcpy(copied, from);

	return copied;

}
