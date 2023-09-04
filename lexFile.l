%{
#include <stdio.h>
#include <stdlib.h>
//#include "tokens.h" //we will delete it with bison later
#include "bisonFile.tab.h"

void yyerror(const char* err);

//int errors=0;
%}

/* Μεταβλητή τύπου int ενσωματωμένη στο Flex. Κάθε φορά που θα συναντά το Flex τον χαρακτήρα νέας γραμμής ('\n'), η μεταβλητή θα αυξάνεται ΑΥΤΟΜΑΤΑ κατά 1 */
%option yylineno
%option noyywrap

%x VALUE
%x COMMENT

LETTER          [a-zA-Z]
SPECIAL_CHAR    [_\- ]
DIGIT           [0-9]
INT             [1-9]{DIGIT}*|0
STRING          {LETTER}+{SPECIAL_CHAR}*{LETTER}*{DIGIT}*{LETTER}*
WHITESPACE      [ \t]

%%
"LinearLayout"          { return LAYOUT_1; }
"RelativeLayout"        { return LAYOUT_2; }
"RadioGroup"            { return RGROUP; }
"TextView"              { return TEXTVIEW; }
"ImageView"             { return IMAGEVIEW; }
"Button"                { return BUTTON; }
"RadioButton"           { return RBUTTON; }
"ProgressBar"           { return PROGRESSBAR; }

"android:"              { return ANDROIDTAG; }
"layout_width"          { return WIDTH; }
"layout_height"         { return HEIGHT; }
"id"                    { return ID;}
"orientation"           { return ORIENTATION; }
"horizontal"            { return HORIZONTAL; }
"vertical"              { return VERTICAL; }
"text"                  { return TEXT; }
"textColor"             { return TEXTCOLOR; }
"src"                   { return SOURCE; }
"padding"               { return PADDING; }
"checkedButton"         { return CHECK_B; }
"max"                   { return MAX; }
"progress"              { return PROGRESS; }
\"                      {BEGIN(VALUE);}
<VALUE>\"               {BEGIN(INITIAL); /*printf("\nString was here!\n"); return ST_VALUE;*/}
<VALUE>{INT}            { return INT;}
<VALUE>{STRING}         { return STRING;}
<VALUE>{INT}{STRING}    {yyerror("String value can't start from integer!\n");}
<VALUE>.                {yyerror("Unrecognised character!\n");}
<VALUE><<EOF>>          {yyerror("You've reached the end of file, without closing a string value!\n");}

"<!--"                  {BEGIN(COMMENT);}
<COMMENT>"-->"          {BEGIN(INITIAL);} //ta comments ta agnooume opote den kanoume return tpt
<COMMENT>.              { }
<COMMENT>"--"           {yyerror("Illegal arguement '--' used in comment!\n"); BEGIN(COMMENT); exit(EXIT_FAILURE);} //gia na stamatisei to diavasma tou arxeioy
<COMMENT><<EOF>>        {yyerror("You've reached the end of file, without closing the comment!\n");}

"<"                     { return START_TAG; }
"/>"                    { return SMALL_CLOSETAG; }
">"                     { return ENDTAG; }
"</"                    { return CLOSETAG; }
"="                     { return ASSIGN; }

{WHITESPACE}            { /* Κενά (space) μέσα στο αρχείο - απλά τα αγνοούμε */ }
\n|\r\n                 { /*το ιδιο με το whitespace και /r/n ειναι αλλαγή γραμμής για windows*/}

.                       { yyerror("Unrecognised character!\n"); }
<<EOF>>                 { return T_EOF;}

%%

//η μεταβλητη yytext ειναι ενσωματομενη στη flex και μας δείχνει την αναγνωρισμένη λέξη
//αντιστοιχα το yylineno μας δειχνει σε ποια γραμμή του κώδικα βρισκόμαστε


/*
Τρεχω αυτό το αρχείο με τις ακόλουθες εντολές:

flex lexertest.l
gcc lex.yy.c -lfl
./a.out testfile1.xml

*/
