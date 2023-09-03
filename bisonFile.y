%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"
#include "lex.yy.h"  //Include Flex-generated header
extern FILE *yyin; //Το yyin είναι ειδική μεταβλητή του Flex.
int yylex();
void yyerror(const char* s);
%}

%token INT STRING 
%token ASSIGN
%token START_TAG SMALL_CLOSETAG ENDTAG CLOSETAG
%token COMMENT
%token WHITESPACE

%token LAYOUT_1 LAYOUT_2
%token RGROUP
%token TEXTVIEW IMAGEVIEW
%token BUTTON 
%token RBUTTON
%token PROGRESSBAR

%token ANDROIDTAG
%token WIDTH HEIGHT
%token ID
%token ORIENTATION
%token TEXT
%token TEXTCOLOR
%token SOURCE
%token PADDING
%token CHECK_B
%token MAX
%token PROGRESS

%token EOF	0

%%

RootElement : 		LinearElement 
			| RelativeElement

LinearElement : 	LinearStartTag elements LinearEndTag

LinearStartTag : 	START_TAG LAYOUT_1 mandContent linear_optional ENDTAG

linear_optional : 	root_optional orientation_attribute 
			| root_optional
 
LinearEndTag : 		CLOSETAG LAYOUT_1 ENDTAG

elements : 		many_comments RootElement elements 
			| many_comments RadioGroup elements 
			| many_comments textview elements 
			| many_comments imageview elements 
			| many_comments buttonElement elements 
			| many_comments progressbar elements 
			| many_comments RootElement many_comments 
			| many_comments RadioGroup many_comments 
			| many_comments textview many_comments
			| many_comments imageview comments 
			| many_comments buttonElement comments 
			| many_comments progressbar comments 

many_comments :		COMMENT many_comments 
			| %empty     

RelativeElement : 	RelativeStartTag relative_elements RelativeEndTag

RelativeStartTag : 	START_TAG LAYOUT_2 mandContent root_optional ENDTAG

root_optional : 	id_attribute 
			| %empty 

RelativeEndTag : 	CLOSETAG LAYOUT_2 ENDTAG

relative_elements : 	elements 
			| %empty 

RadioGroup : 		RadioGroupStart radio_element RadioGroupEnd

RadioGroupStart : 	START_TAG RGROUP mandcontent radiogroup_opt ENDTAG
 
radiogroup_opt : 	id_attribute checkedbutton_attribute 
			| id_attribute 
			| checkedbutton_attribute

RadioGroupEnd : 	CLOSETAG RGROUP ENDTAG

radio_element : 	many_comments RadioButton radio_element 
         		| many_elements RadioButton many_elements

buttonElement : 	START_TAG BUTTON button_mandatory_cont button_optional_cont SMALL_CLOSETAG

button_mandatory_cont : mandcontent text_attribute

button_optional_cont : root_optional padding_attribute 
			| root_optional

textview :		START_TAG TEXTVIEW button_mandatory_cont textview_opt SMALL_CLOSETAG

textview_opt : 		root_optional textColor_attribute
			| root_optional

imageview : 		START_TAG IMAGEVIEW imageview_mand button_optional_cont SMALL_CLOSETAG

imageview_mand : 	mandcontent src_attribute

progressbar : 		START_TAG PROGRESSBAR mandcontent progressbar_opt SMALL_CLOSETAG

progressbar_opt : 	root_optional max_attribute progress_attribute 
			| root_optional max_attribute 
			| root_optional progress_attribute 
			| root_optional 

RadioButton : 		START_TAG RBUTTON button_mandatory_cont root_optional SMALL_CLOSETAG

 
mandContent : 		ANDROIDTAG WIDTH ASSIGN value ANDROIDTAG HEIGHT ASSIGN value

text_attribute : 	ANDROIDTAG TEXT ASSIGN STRING

id_attribute : 		ANDROIDTAG ID ASSIGNS STRING

padding_attribute : 	ANDROIDTAG PADDING ASSIGNS INT

textColor_attribute :	ANDROIDTAG TEXTCOLOR ASSIGNS STRING

src_attribute :		ANDROIDTAG SOURCE ASSIGNS STRING

max_attribute : 	ANDROIDTAG MAX ASSIGNS INT

progress_attribute : 	ANDROIDTAG PROGRESS ASSIGNS INT

checkedbutton_attribute : ANDROIDTAG CHECK_B ASSIGNS STRING

orientation_attribute : ANDROIDTAG ORIENTATION ASSIGNS VERTICAL 
			| ANDROIDTAG ORIENTATION ASSIGNS HORIZONTAL

value :			STRING 
			| INT


%%
void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main(int argc, char* argv[]) {

    yyin = fopen(argv[1], "r"); 

    if (yyin == NULL) {
        printf("%s: File not found\n", argv[1]);
        return 1;
    }

	yyparse(); //κάνει συντακτική ανάλυση

    fclose(yyin);
	return 0;
}
