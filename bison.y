%{
#include <stdio.h>
#include <math.h>
#include "SymbolTable.h"

void yyerror(char *); 
extern FILE *yyin;								
extern FILE *yyout;		

int decl_error = 0;	// Counter for undeclared vars
int data_type = 0;	// [1,3] corresponding to each data type
double temp = 0;	// The data value of an identifier
int flag = 0; 		// Triggered when there is a rule using a BINARY_ASSIGNMENT_OPERATOR
char* tempID;		// The most recent recognised identifier
char *data[] = {"int", "char", "double"}; // Data types to be checked
%}

// The types of semantic values that can be returned
%union {
char* string;	// String literals 
}
	
%token LEFT_PARENTHESIS
%token RIGHT_PARENTHESIS  
%token LEFT_BRACKET
%token RIGHT_BRACKET  
%token LEFT_CURLY_BRACKET
%token RIGHT_CURLY_BRACKET 
%token QUESTION_MARK
%token GREEK_QUESTION_MARK
%token COLON 
%token UNARY_OPERATOR
%token BINARY_OPERATOR
%token ASTERISK
%token COMMA
%token UNARY_ASSIGNMENT_OPERATOR
%token BINARY_ASSIGNMENT_OPERATOR
%token INT
%token CHARACTER
%token BOOL
%token DOUBLE_
%token IF
%token ELSE
%token FOR
%token CONTINUE
%token BREAK
%token RETURN
%token DELETE
%token NEW
%token VOID
%token BYREF
%token KEYWORD_EXP
%token CHAR
%token STRING
%token INTEGER
%token DOUBLE
%token <string> ID

%left INT CHARACTER BOOL DOUBLE_ 
%left BINARY_OPERATOR UNARY_OPERATOR UNARY_ASSIGNMENT_OPERATOR BINARY_ASSIGNMENT_OPERATOR VOID BYREF KEYWORD_EXP CHAR STRING INTEGER DOUBLE
%left ASTERISK QUESTION_MARK COLON COMMA GREEK_QUESTION_MARK
%left LEFT_PARENTHESIS RIGHT_PARENTHESIS LEFT_BRACKET RIGHT_BRACKET LEFT_CURLY_BRACKET RIGHT_CURLY_BRACKET
%left ID IF ELSE FOR CONTINUE BREK RETURN DELETE

%%

program: A
	;

A: /* empty */
	| A statement
	| error 
	;
	
statement: variable_statement 
	| function_statement
	| function_declaration
	;
	
variable_statement: returned_value_type state B GREEK_QUESTION_MARK
	;

B: /* empty */
	| B COMMA state 
	;
	
state: ID D {addId ($1);	// Add ID to the symbol table
			setValue ($1, data_type);}	//Add the data value of the ID 
	;
	
D: /* empty */
	| LEFT_BRACKET expression RIGHT_BRACKET
	;

	
function_statement: returned_value_type ID LEFT_PARENTHESIS E RIGHT_PARENTHESIS GREEK_QUESTION_MARK {addId ($2);}	// Add ID to the symbol table
		;

E: /* empty */
	| parameters_list
	;

returned_value_type: data_type
	| VOID
	;
	
parameters_list: parameter F
	;

F: /* empty */
	| F  COMMA parameter
	;
	
parameter: G data_type ID {addId ($3);}	// Add ID to the symbol table
	;
	
G: /* empty */
	| BYREF
	;
	
function_declaration: returned_value_type ID LEFT_PARENTHESIS E RIGHT_PARENTHESIS LEFT_CURLY_BRACKET H I RIGHT_CURLY_BRACKET {addId ($2);}	// Add ID to the symbol table
	;

H: /* empty */
	| H statement
	;

I: /* empty */
	| I clause
	;
	
clause: GREEK_QUESTION_MARK
	| expression GREEK_QUESTION_MARK
	| LEFT_CURLY_BRACKET I RIGHT_CURLY_BRACKET
	| IF LEFT_PARENTHESIS expression RIGHT_PARENTHESIS clause X
	| J FOR LEFT_PARENTHESIS K GREEK_QUESTION_MARK K GREEK_QUESTION_MARK K RIGHT_PARENTHESIS clause
	| CONTINUE L GREEK_QUESTION_MARK
	| BREAK L GREEK_QUESTION_MARK
	| RETURN K GREEK_QUESTION_MARK
	;
	
X: /* empty */
	| ELSE clause
	;
	
J: /* empty */
	| ID COLON	{if (decl_error == 0) {
					printf("\nUndeclared ID(s) occurence(s): %s", $1);
					decl_error++;}
				else{
					if (!isDeclared ($1))
						printf(", %s", $1);			
					}
				}
	;
	
K: /* empty */
	| expression
	;
	
L: /* empty */
	| ID	{if (decl_error == 0) {
				printf("\nUndeclared ID(s) occurence(s): %s", $1);
				decl_error++;}
			else {
				if (!isDeclared ($1))
					printf(", %s", $1);			
				}
			}
	;
	
expression_list: expression O
	;

O: /* empty */
	| O COMMA expression
	;

expression:	ID {if (decl_error == 0) {
					printf("\nUndeclared ID(s) occurence(s): %s", $1);
					decl_error++;}
				else{
					if (!isDeclared ($1))
						printf(", %s", $1);	
					}
				tempID = $1;
				}
	| KEYWORD_EXP
	| INTEGER 	{if (flag == 1){
					getValue (tempID, &temp);
					if (temp == 1) {	// Check if the ID has been declared as an integer 
						}
					else {
						printf("\n%s has been declared as a(n) %s!!!", tempID, data[(int) temp - 1]);
						decl_error = 0; 
						}
					}
				flag = 0;
				}
	| CHAR		{if (flag == 1) {
					getValue (tempID, &temp);
					if (temp == 2) {	// Check if the ID has been declared as a char
						}
					else {
						printf("\n%s has been declared as a(n) %s!!!", tempID, data[(int) temp - 1]);
						decl_error = 0;
						}
					}
				flag = 0;
				}
	| DOUBLE	{if (flag == 1) {
					getValue (tempID, &temp);
					if (temp == 3) {	// Check if the ID has been declared as a double 
						}
					else {
						printf("\n%s has been declared as a(n) %s!!!", tempID, data[(int) temp - 1]);
						decl_error = 0;
						}
					}
				flag = 0;
				}
	| STRING	{if (flag == 1) {
					getValue (tempID, &temp);
					if (temp == 2) {	// Check if the ID has been declared as a char 
						}
					else {
						printf("\n%s has been declared as a(n) %s!!!", tempID, data[(int) temp - 1]);
						decl_error = 0;
						}
					}
				flag = 0;
				}
	| ID LEFT_PARENTHESIS test M RIGHT_PARENTHESIS 
				{if (decl_error == 0) {
					printf("\nUndeclared ID(s) occurence(s): %s", $1);
					decl_error++;}
				else{
					if (!isDeclared ($1))
						printf(", %s", $1);			
					}
				}
	| expression LEFT_BRACKET expression RIGHT_BRACKET
	| UNARY_OPERATOR expression
	| expression BINARY_OP expression
	| UNARY_ASSIGNMENT_OPERATOR expression
	| expression UNARY_ASSIGNMENT_OPERATOR
	| expression BINARY_ASSIGNMENT_OPERATOR expression {flag = 1;}	// Trigger the flag
	| LEFT_PARENTHESIS test
	| expression QUESTION_MARK expression COLON expression
	| NEW data_type N
	| DELETE expression
	;

test: M RIGHT_PARENTHESIS 
	| data_type RIGHT_PARENTHESIS expression
	;

M: /* empty */
	| expression_list
	;
	
BINARY_OP: ASTERISK
	| BINARY_OPERATOR
	;

N: /* empty */
	| LEFT_BRACKET expression RIGHT_BRACKET
	
data_type: basic_data_type C
	;

basic_data_type: INT 	{data_type = 1;}	// Assign 1 to INT data type
	| CHARACTER 		{data_type = 2;}	// Assign 2 to CHAR data type
	| BOOL 				
	| DOUBLE_ 			{data_type = 3;}	// Assign 3 to DOUBLE data type
	;
	
C: /* empty */
	| C ASTERISK
	;

%%


										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
