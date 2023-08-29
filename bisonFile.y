%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "y.tab.h"
    #include "lex.yy.h" //Include Flex-generated header

    int yylex();
    void yyerror(const char* s);
%}

%token INT STRING
%token QMARKS EQUALS
%token OPENTAG CLOSETAG SLASH
%token DASH EXMARK
%token COMMENT
%token NEWLINE SPACE

%%
void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main(void) {
    yyparse(); //parse the input
    return 0;
}