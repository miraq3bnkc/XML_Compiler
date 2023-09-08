%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "bisonFile.tab.h"

int errors=0;
extern FILE *yyin; 					//Το yyin είναι ειδική μεταβλητή του Flex.
extern int yylineno;
extern int yyparse();
int yylex();
void yyerror(const char* s);
%}

%define parse.error verbose

%union{
	int integer;
}

%token <integer> INT 
%token STRING
%token ASSIGN										"="
%token START_TAG								"<"
%token SMALL_CLOSETAG 					"/>"
%token ENDTAG 									">"
%token CLOSETAG									"</"

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
%token VERTICAL
%token HORIZONTAL
%token TEXT
%token TEXTCOLOR
%token SOURCE
%token PADDING
%token CHECK_B
%token MAX
%token PROGRESS

%token T_EOF	0

%%

RootElement : 			LinearElement
										| RelativeElement


LinearElement : 		LinearStartTag elements LinearEndTag
										|LinearStartTag elements LinearEndTag T_EOF {printf("End of file\n");}


LinearStartTag : 		START_TAG LAYOUT_1 mandContent linear_optional ENDTAG

linear_optional : 						id_attribute orientation_attribute
										| id_attribute
										| orientation_attribute
										| %empty

LinearEndTag : 			CLOSETAG LAYOUT_1 ENDTAG

elements : 								 RootElement elements
										|  RadioGroup elements
										|  textview elements
										|  imageview elements
										|  buttonElement elements
										|  progressbar elements
										|  RootElement
										|  RadioGroup
										|  textview
										|  imageview
										|  buttonElement
										|  progressbar

RelativeElement : 						RelativeStartTag relative_elements RelativeEndTag

RelativeStartTag : 						START_TAG LAYOUT_2 mandContent root_optional ENDTAG

root_optional : 						id_attribute
										| %empty

RelativeEndTag : 						CLOSETAG LAYOUT_2 ENDTAG

relative_elements : 					elements
										| %empty

RadioGroup : 							RadioGroupStart radio_element RadioGroupEnd

RadioGroupStart : 						START_TAG RGROUP mandContent radiogroup_opt ENDTAG

radiogroup_opt : 						id_attribute checkedbutton_attribute
										| id_attribute
										| checkedbutton_attribute
										| %empty

RadioGroupEnd : 						CLOSETAG RGROUP ENDTAG

radio_element : 						 RadioButton radio_element
         								| RadioButton

buttonElement : 						START_TAG BUTTON button_mandatory_cont button_optional_cont SMALL_CLOSETAG

button_mandatory_cont : 				mandContent text_attribute

button_optional_cont :	 				id_attribute padding_attribute
										| id_attribute
										| padding_attribute
										| %empty

textview :								START_TAG TEXTVIEW button_mandatory_cont textview_opt SMALL_CLOSETAG

textview_opt : 							id_attribute textColor_attribute
										| id_attribute
										| textColor_attribute
										| %empty

imageview : 							START_TAG IMAGEVIEW imageview_mand button_optional_cont SMALL_CLOSETAG

imageview_mand : 						mandContent src_attribute

progressbar : 							START_TAG PROGRESSBAR mandContent progressbar_opt SMALL_CLOSETAG

progressbar_opt : 						id_attribute max_attribute progress_attribute
										| id_attribute max_attribute
										| id_attribute progress_attribute
										| id_attribute
										| max_attribute
										| progress_attribute
										| %empty

RadioButton : 							START_TAG RBUTTON button_mandatory_cont root_optional SMALL_CLOSETAG


mandContent : 							ANDROIDTAG WIDTH ASSIGN value ANDROIDTAG HEIGHT ASSIGN value

text_attribute : 						ANDROIDTAG TEXT ASSIGN STRING

id_attribute : 							ANDROIDTAG ID ASSIGN STRING

padding_attribute : 					ANDROIDTAG PADDING ASSIGN INT

textColor_attribute :					ANDROIDTAG TEXTCOLOR ASSIGN STRING

src_attribute :							ANDROIDTAG SOURCE ASSIGN STRING

max_attribute : 						ANDROIDTAG MAX ASSIGN INT

progress_attribute : 					ANDROIDTAG PROGRESS ASSIGN INT

checkedbutton_attribute : 				ANDROIDTAG CHECK_B ASSIGN STRING

orientation_attribute :					ANDROIDTAG ORIENTATION ASSIGN VERTICAL
										| ANDROIDTAG ORIENTATION ASSIGN HORIZONTAL


value :									STRING
										| INT


%%
/*void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}*/

void yyerror(const char* err){
    errors++;
    printf("\nERROR: (line %d) %s\n",yylineno,err);

    if(errors==10){
        printf("\nMaximum number of errors found.\n");
        exit(EXIT_FAILURE);
    }
}

int main(int argc, char* argv[]) {

    yyin = fopen(argv[1], "r");

    if (yyin == NULL) {
        printf("%s: File not found\n", argv[1]);
        return 1;
    }
		int result = yyparse(); //κάνει συντακτική ανάλυση
		printf("%d",result);
		if (result == 0) {
		    printf("Parsing was successful!\n");
		    // Perform actions for successful parsing
		} else {
		    printf("Parsing encountered an error.\n");
		    // Handle the parsing error, print error messages, etc.
		}

	if(errors==0){
		printf("XML file compiled successfully with 0 errors!\n");
	}

    fclose(yyin);

	return 0;
}
