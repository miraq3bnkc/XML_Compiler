%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "bisonFile.tab.h" // including tokens from bison

void yyerror(const char* err);

int invalid_comment =0;

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
"id"                    { return ID;}
"orientation"           { return ORIENTATION; }
"text"                  { return TEXT; }
"textColor"             { return TEXTCOLOR; }
"src"                   { return SOURCE; }
"padding"               { return PADDING; }
"checkedButton"         { return CHECK_B; }
"max"                   { return MAX; }
"progress"              { return PROGRESS; }
"layout_width"          { return WIDTH; }
"layout_height"         { return HEIGHT; }
"numberOfButtons"       { yylval.integer=atoi(yytext); return NUM_BUTTONS;}

\"                      {BEGIN(VALUE);}
<VALUE>\"               {BEGIN(INITIAL);}
<VALUE>"vertical"       { return VERTICAL; }
<VALUE>"horizontal"     { return HORIZONTAL; }
<VALUE>"wrap_content"   { return WRAP_CONTENT; }
<VALUE>"match_parent"   { return MATCH_PARENT; }
<VALUE>{INT}            { yylval.integer=atoi(yytext); return INT;}
<VALUE>{STRING}         { yylval.string=strdup(yytext); return STRING;}
<VALUE>{INT}{STRING}    {yyerror("String value can't start from integer!\n");}
<VALUE>.                {yyerror("Unrecognised character!\n");}
<VALUE><<EOF>>          {yyerror("You've reached the end of file, without closing a string value!\n");}

"<!--"                  {BEGIN(COMMENT);}
<COMMENT>"-->"          {BEGIN(INITIAL);} //comments cannot be tokens we just ignore them , no return statements
<COMMENT>.              { if(invalid_comment==1){ yyerror("You can't comment here!\n");} }
<COMMENT>"--"           {yyerror("Illegal arguement '--' used in comment!\n"); BEGIN(COMMENT);}
<COMMENT><<EOF>>        {yyerror("You've reached the end of file, without closing the comment!\n");}

"<"                     { invalid_comment=1; return START_TAG; }
"/>"                    { invalid_comment=0; return SMALL_CLOSETAG; }
">"                     { invalid_comment=0; return ENDTAG; }
"</"                    { invalid_comment=1; return CLOSETAG; }
"="                     { return ASSIGN; }

{WHITESPACE}            { /* Κενά (space) μέσα στο αρχείο - απλά τα αγνοούμε */ }
\n|\r\n                 { /*το ιδιο με το whitespace και /r/n ειναι αλλαγή γραμμής για windows*/}

.                       { yyerror("Unrecognised character!\n"); }
<<EOF>>                 { return T_EOF;}

%%

//η μεταβλητη yytext ειναι ενσωματομενη στη flex και μας δείχνει την αναγνωρισμένη λέξη
//αντιστοιχα το yylineno μας δειχνει σε ποια γραμμή του κώδικα βρισκόμαστε
