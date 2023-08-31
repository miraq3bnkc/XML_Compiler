%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "y.tab.h"
    #include "lex.yy.h" //Include Flex-generated header
    extern FILE *yyin;
    int yylex();
    void yyerror(const char* s);
%}

%token INT STRING LETTER
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

%token EOF

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

many_comments :		COMMENT <many_comments> 
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

radio_element : 	many_elements RadioButton radio_element 
         		| many_elements RadioButton many_elements


%%
void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main(void) {
    yyparse(); //parse the input
    return 0;
}