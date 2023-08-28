%{
#include <stdio.h>
#include "y.tab.h"  // Include the Bison-generated header


// Define a function for error handling
void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}
%}
int        [1-9][0-9]* | 0 
commentText        [^-]+
string        .*
%%


\<        {return OPENTAG;}
\>        {return CLOSETAG;}
\/        {return SLASH;}
\!        {return EXMARK;}
{int}        {return INT; }
{commentText}        {return COMMENT;}
\s*        {return SPACE ;} [a]
\-        {return DASH;}
{string}                {return STRING};
%%


int main(void) {
    yylex(); // Run the lexer
    return 0;
}


[a]den eimaste sigoures oti to xreiazomaste