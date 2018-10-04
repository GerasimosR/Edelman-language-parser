flex flex.l
bison -d bison.y 
gcc bison.tab.c lex.yy.c SymbolTable.c -lfl