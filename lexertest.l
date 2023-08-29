%{
#include <stdio.h>
#include <stdlib.h>
#include "tokens.h" //we will delete it with bison later

void t_print(int token_id);
%}

/* Μεταβλητή τύπου int ενσωματωμένη στο Flex. Κάθε φορά που θα συναντά το Flex τον χαρακτήρα νέας γραμμής ('\n'), η μεταβλητή θα αυξάνεται ΑΥΤΟΜΑΤΑ κατά 1 */
%option yylineno

%x VALUE
%x COMMENT

LETTER      [a-zA-Z]
INT         [1-9][0-9]*|0
STRING      .*
WHITESPACE  [ \t]

%%

"LinearLayout"          { t_print(LAYOUT_1); return LAYOUT_1; }
"RelativeLayout"        { t_print(LAYOUT_2); return LAYOUT_2; }
"RadioGroup"            { t_print(RGROUP); return RGROUP; }
"TextView"              { t_print(TEXTVIEW); return TEXTVIEW; }
"ImageView"             { t_print(IMAGEVIEW); return IMAGEVIEW; }
"Button"                { t_print(BUTTON); return BUTTON; }
"RadioButton"           { t_print(RBUTTON); return RBUTTON; }
"ProgressBar"           { t_print(PROGRESSBAR); return PROGRESSBAR; }

"android:"              { t_print(ANDROIDTAG); return ANDROIDTAG; }
"layout_width"          { t_print(WIDTH); return WIDTH; }
"layout_height"         { t_print(HEIGHT); return HEIGHT; }
"id"                    { t_print(ID); return ID;}
"orientation"           { t_print(ORIENTATION); return ORIENTATION; }
"text"                  { t_print(TEXT); return TEXT; }
"textColor"             { t_print(TEXTCOLOR); return TEXTCOLOR; }
"src"                   { t_print(SOURCE); return SOURCE; }
"padding"               { t_print(PADDING); return PADDING; }
"checkedButton"         { t_print(CHECK_B); return CHECK_B; }
"max"                   { t_print(MAX); return MAX; }
"progress"              { t_print(PROGRESS); return PROGRESS; }

\"                      {BEGIN(VALUE);}
<VALUE>\"               {BEGIN(INITIAL); printf("\nString was here!\n"); return ST_VALUE;}
<VALUE>{INT}            {t_print(INT); return INT;}
<VALUE><<EOF>>          {printf("You've reached the end of file, without closing a string value!\n");}

"<!--"                  {BEGIN(COMMENT);}
<COMMENT>"-->"          {BEGIN(INITIAL); printf("\n\nComment was here!\n\n"); return T_COMMENT;}
<COMMENT>^(--)          {/*κάπως θα έπρεπε να βγάζει ερρορ*/ }
<COMMENT><<EOF>>          {printf("You've reached the end of file, without closing the comment!\n");}

"<"                     { t_print(START_TAG); return START_TAG; }
"/>"                    { t_print(SMALL_CLOSETAG); return SMALL_CLOSETAG; }
">"                     { t_print(ENDTAG); return ENDTAG; }
"</"                    { t_print(CLOSETAG); return CLOSETAG; }
"="                     { t_print(ASSIGN); return ASSIGN; }

{WHITESPACE}        { /* Κενά (space) μέσα στο αρχείο - απλά τα αγνοούμε */ }
\n                  { /*το ιδιο με το whitespace*/}
\r\n                {/*αλλαγή γραμμής για windows*/}

.                   { printf("Unrecognised character at line %d!\n", yylineno); }
<<EOF>>             { return T_EOF;}

%%

int main(int argc, char* argv[]) {

    int token; 

    yyin = fopen(argv[1], "r"); // Το yyin είναι ειδική μεταβλητή του Flex.
                                // Ισοδυναμεί με ένα FILE Pointer για να διαβάζει το αρχείο ο Flex

    if (yyin == NULL) {
        printf("%s: File not found\n", argv[1]);
        return 1;
    }

    do { // Μέχρι να φτάσουμε στο EOF διαβάζουμε κάθε Token μέσα απο το αρχείο.
        token = yylex();
    } while (token != 0);

    return 0;
}

void t_print(int token_id){
    printf("Found %s (%d) at line %d\n",yytext,token_id,yylineno);
}

//η μεταβλητη yytext ειναι ενσωματομενη στη flex και μας δείχνει την αναγνωρισμένη λέξη
//αντιστοιχα το yylineno μας δειχνει σε ποια γραμμή του κώδικα βρισκόμαστε

/*
Τρεχω αυτό το αρχείο με τις ακόλουθες εντολές:

flex lexertest.l
gcc lex.yy.c -lfl
./a.out testfile1.xml

*/