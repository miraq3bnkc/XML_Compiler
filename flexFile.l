%{
    #include <stdio.h>
    #include "y.tab.h" //Include Bison-generated header

//Define a function for error handling
void yyerror(const char *s) {
    fprint(stderr, "Error: %s\n", s);
}

%}

int             [1-9][0-9]*|0
commentText     [^-]+
string          .*

%%

\<      {return OPENTAG;}
\>      {return CLOSETAG;}
\/      {return SLASH;}
\!      {return EXMARK;}
{int}   {return INT;}
{commentText}   {return COMMENT;}
\s*     {return SPACE;}
\-      {return DASH;}
{string}    {return STRING;}

%%

int main(void) {
    yylex(); //RUn lexer
    return 0;
}