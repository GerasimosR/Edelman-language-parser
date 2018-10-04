%{
#include <math.h>
#include "bison.tab.h" 
#include <stdlib.h>
#include <string.h>
%}
CHAR 	\"(\\.|[^"])\"
STRING	\"(\\.|[^"])*\"
INTEGER [0-9]+
DOUBLE 	[0-9]+("."[0-9]+)? 
ID      ([a-z]|[A-Z]|"_")[a-zA-Z0-9_]*
INT int
CHARACTER char
BOOL bool
DOUBLE_ double
IF if
ELSE else
FOR for
CONTINUE continue
BREAK break
RETURN return
DELETE delete
NEW new
VOID void
BYREF byref
KEYWORD_EXP true|false|NULL

%%

"(" 	{fprintf(stderr,"%s",yytext); return LEFT_PARENTHESIS;}

")" 	{fprintf(stderr,"%s",yytext); return RIGHT_PARENTHESIS;}

"[" 	{fprintf(stderr,"%s",yytext); return LEFT_BRACKET;}

"]" 	{fprintf(stderr,"%s",yytext); return RIGHT_BRACKET;}

"{" 	{fprintf(stderr,"%s",yytext); return LEFT_CURLY_BRACKET;}

"}" 	{fprintf(stderr,"%s",yytext); return RIGHT_CURLY_BRACKET;}

"?"		{fprintf(stderr,"%s",yytext); return QUESTION_MARK;}

";"		{fprintf(stderr,"%s",yytext); return GREEK_QUESTION_MARK;}

":"		{fprintf(stderr,"%s",yytext); return COLON;}

"&"|"+"|"-"|"!"		{fprintf(stderr,"%s",yytext); return UNARY_OPERATOR;}

"/"|"%"|"+"|"-"|"<"|">"|"<="|">="|"=="|"!="|"&&"|"||"	{fprintf(stderr,"%s",yytext); return BINARY_OPERATOR;}

"*"		{fprintf(stderr,"%s",yytext); return ASTERISK;}

"," 	{fprintf(stderr,"%s",yytext); return COMMA;}

"++"|"--"		{fprintf(stderr,"%s",yytext); return UNARY_ASSIGNMENT_OPERATOR;}

"="|"*="|"/="|"%="|"+="|"-="	{fprintf(stderr,"%s",yytext); return BINARY_ASSIGNMENT_OPERATOR;}

{INT}  	{fprintf(stderr,"%s",yytext); return INT;}

{CHARACTER}  	{fprintf(stderr,"%s",yytext); return CHARACTER;}

{BOOL}  	{fprintf(stderr,"%s",yytext); return BOOL;}

{DOUBLE_}  	{fprintf(stderr,"%s",yytext); return DOUBLE_;}

{IF}	{fprintf(stderr,"%s",yytext); return IF;}

{ELSE}	{fprintf(stderr,"%s",yytext); return ELSE;}

{FOR}	{fprintf(stderr,"%s",yytext); return FOR;}

{CONTINUE}	{fprintf(stderr,"%s",yytext); return CONTINUE;}

{BREAK}	{fprintf(stderr,"%s",yytext); return BREAK;}

{RETURN}	{fprintf(stderr,"%s",yytext); return RETURN;}

{DELETE}	{fprintf(stderr,"%s",yytext); return DELETE;}

{NEW}	{fprintf(stderr,"%s",yytext); return NEW;}

{VOID}	{fprintf(stderr,"%s",yytext); return VOID;}

{BYREF}	{fprintf(stderr,"%s",yytext); return BYREF;}

{KEYWORD_EXP}	{fprintf(stderr,"%s",yytext); return KEYWORD_EXP;}

{CHAR} 		{fprintf(stderr,"%s",yytext); return CHAR;}

{STRING} 	{fprintf(stderr,"%s",yytext); return STRING;}

{INTEGER} 	{fprintf(stderr,"%s",yytext); return INTEGER;}

{DOUBLE} 	{fprintf(stderr,"%s",yytext); return DOUBLE;}

{ID}        {fprintf(stderr,"%s",yytext); yylval.string = (char*)malloc (yyleng+1);
			 strcpy (yylval.string, yytext); return ID;}

"//".* 		{fprintf(stderr,"%s",yytext);;}	// Single line comment

"/*"[^"*/"]*"*/" 	{fprintf(stderr,"%s",yytext);}	//Multi line comment

[ \t\r]+   {fprintf(stderr,"%s",yytext);}	// Eat up whitespace

[\n]       {fprintf(stderr,"%s",yytext); yylineno = yylineno + 1;}	// Counter for newlines

.          {fprintf(stderr,"%s",yytext);}

%%

int counter = 0;	// Counter for syntax errors
int lines[1000];
int main(int argc, char *argv[])
{
	if(argc == 2) {
		yyin = fopen(argv[1], "r");	// Read input from a file
		setvbuf(stdout, NULL, _IOFBF, 0);	// Defining stdout to be full buffered; data is written once the buffer is full
		if(!yyparse() && counter==0)	// If parsing is successful yyparse returns 0
			fprintf(stderr, "\nParsing complete.");
		else 
			fprintf(stderr, "\nParsing failed,error detected in lines: ");
			int i;
			for (i = 0; i < counter; i++){
				if (i == 0){
					fprintf(stderr, " %d ", lines[i]);
				}else{ 
					fprintf(stderr, ", %d ", lines[i]);
				}
			}
			fprintf(stderr, "\n\a");
		fclose(yyin);
	}
	else{
		printf("File not found\n");
	}
	printf("\nTotal syntax error(s): %d\n", counter);
	return 0;
}

void yyerror(char *s) {
    lines[counter] = yylineno;
	counter++;
}
