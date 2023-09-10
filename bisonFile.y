%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "bisonFile.tab.h"

int android_process_value; // To store the android:process value
int android_max_value;    // To store the android:max value
int errors=0;
extern FILE *yyin; 					//Το yyin είναι ειδική μεταβλητή του Flex.
extern int yylineno;
extern int yyparse();
extern YYSTYPE yylval; // Token value
int yylex();
void yyerror(const char* s);

//FUNCTIONS AND VALUES FOR COMPARING CHECKEDBUTTON WITH RADIOBUTTON IDS
void cmp_check();
void save_rb_id(char* id);
int rbs=1; //number of radio buttons (radiogroup must always contain at leat one , so we initialize it to 1)
int rb_state=0; //state=1 for when we are defining a radiogroup else state=0
char **radio_button_id;
char* checked_value;

int line[2];
int number_value=0;
void check_number();

//NEW CODE, BE CAREFUL
//function and variables for unique id
void idUnique(char* id);
char** unique_ids = NULL;  // Array pointer for storing unique IDs
int unique_id_count = 0;  // Current number of unique IDs
int unique_ids_size = 0;  // Current size of the array

%}

%define parse.error verbose

%union{
	int integer;
	char* string;
}

%token <integer> INT						"int"
%token <string> STRING
%token MATCH_PARENT							"match_parent"
%token WRAP_CONTENT							"wrap_content"
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
%token <integer> NUM_BUTTONS

%token T_EOF	0

%type<string> id_attribute checkedbutton_attribute

%%

RootElement : 			LinearElement
										| RelativeElement


LinearElement : 		LinearStartTag elements LinearEndTag


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

RadioGroupStart : 						START_TAG RGROUP radiogroup_mand radiogroup_opt ENDTAG							{rb_state=1;}

radiogroup_mand :						mandContent numofButtons_attribute

radiogroup_opt : 						id_attribute checkedbutton_attribute
										| id_attribute
										| checkedbutton_attribute
										| %empty

RadioGroupEnd : 						CLOSETAG RGROUP ENDTAG												{ cmp_check(); check_number(); rb_state=0; rbs=1;}
																											/*initialize values as before*/
radio_element : 						 RadioButton radio_element
         								| RadioButton

buttonElement : 						START_TAG BUTTON button_mandatory_cont button_optional_cont SMALL_CLOSETAG

button_mandatory_cont : 				mandContent text_attribute

button_optional_cont :	 				id_attribute padding_attribute
										| id_attribute
										| padding_attribute
										| %empty

textview :					START_TAG TEXTVIEW button_mandatory_cont textview_opt SMALL_CLOSETAG

textview_opt : 			id_attribute textColor_attribute
										| id_attribute
										| textColor_attribute
										| %empty

imageview : 				START_TAG IMAGEVIEW imageview_mand button_optional_cont SMALL_CLOSETAG

imageview_mand : 		mandContent src_attribute

progressbar : 			START_TAG PROGRESSBAR mandContent progressbar_opt SMALL_CLOSETAG

progressbar_opt : 	id_attribute max_attribute progress_attribute
										| id_attribute max_attribute
										| id_attribute progress_attribute
										| id_attribute
										| max_attribute
										| progress_attribute
										| %empty

RadioButton : 							START_TAG RBUTTON button_mandatory_cont root_optional SMALL_CLOSETAG		{rbs++; }
/*increment rbs counter after declaration of every radiobutton*/

mandContent : 							ANDROIDTAG WIDTH ASSIGN value ANDROIDTAG HEIGHT ASSIGN value

text_attribute : 						ANDROIDTAG TEXT ASSIGN STRING

id_attribute : 							ANDROIDTAG ID ASSIGN STRING													{save_rb_id($4); idUnique($4);}

padding_attribute : 				ANDROIDTAG PADDING ASSIGN INT

textColor_attribute :				ANDROIDTAG TEXTCOLOR ASSIGN STRING

src_attribute :							ANDROIDTAG SOURCE ASSIGN STRING

max_attribute : 						ANDROIDTAG MAX ASSIGN max_value

max_value:									INT
														{
															android_max_value = $1;
														}

progress_attribute : 				ANDROIDTAG PROGRESS ASSIGN progress_value
														{
																if (android_process_value < 0 || android_process_value > android_max_value && android_max_value!=0) {
																		fprintf(stderr, "Error: android:process value out of range %d\n",android_max_value );
																		exit(1);
																}

														};

progress_value:						  INT
												    {
												        android_process_value = $1;
												    }


checkedbutton_attribute : 	ANDROIDTAG CHECK_B ASSIGN STRING											{checked_value=$4; line[0]=yylineno;}

orientation_attribute :			ANDROIDTAG ORIENTATION ASSIGN VERTICAL
														| ANDROIDTAG ORIENTATION ASSIGN HORIZONTAL

numofButtons_attribute :				ANDROIDTAG NUM_BUTTONS ASSIGN INT											{ line[1]=yylineno; number_value=$4;}

value :											WRAP_CONTENT
														| MATCH_PARENT
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

/*Function to check if numberOfButtons attribute is equal to the actual number of RadioButtons inside a RadioGroup*/
void check_number(){
	int x=rbs-1;
	if(x<number_value){
		printf("\nThere should be %d RadioButtons, as declared by numberOfButtons attribute at line %d!",number_value,line[1]);
		yyerror("There were less RadioButtons defined in this RadioGroup than what it was expected.");
	}
	else if(x>number_value){
		printf("\nThere should be %d RadioButtons, as declared by numberOfButtons attribute at line %d!",number_value,line[1]);
		yyerror("There were more RadioButtons defined in this RadioGroup than what it was expected.");
	}
}

/*Compare if the value of checkedButton is equal to one of the radiobuttons ids*/
void cmp_check(){
	int x=0, y=0;
	if(checked_value!=NULL){
		for(int i=0;i<rbs-1;i++){
			if(radio_button_id[i]!=NULL){
				if(strcmp(checked_value,radio_button_id[i])==0){
					x++;
					//if x>0 one id matches the checkedButton attribute
				}
				y++;
				//if y>0 at least one id attribute was not null
			}
		}
		if(x==0 && y!=0){
		//if there were no matches , but there was a not null id attribute
			printf("\nNo match with checkedbutton attribute at line %d!",line[0]);
			yyerror("Checked all android:id attributes of RadioButton elements.");
		}
	}
}

/*save the string ids of the radiobuttons declared*/
void save_rb_id(char* id){
	int i;
	if(rb_state==0){
		/*do nothing*/
	}
	else if(rb_state==1){
		radio_button_id[rbs-1]=id;
	}
	else{
		printf("some exception occured\n");
	}
	radio_button_id=(char**)realloc(radio_button_id,(rbs+1)*sizeof(char*));
}

//NEW CODE, BE CAREFUL

void idUnique(char* id){
	// Check for duplicate ID
    for (int i = 0; i < unique_id_count; i++) {
        if (strcmp(id, unique_ids[i]) == 0) {
            fprintf(stderr, "\nError: Duplicate ID '%s' at line %d", id, yylineno);
            yyerror("Duplicate ID attribute found.");
            break;
        }
    }

    // Resize the array if necessary
    if (unique_id_count >= unique_ids_size) {
        unique_ids_size += 10;  // Increase the size by 10
        unique_ids = (char**)realloc(unique_ids, unique_ids_size * sizeof(char*));
    }

    // Add the unique ID to the array
    unique_ids[unique_id_count++] = strdup(id);
}

//END OF NEW CODE

int main(int argc, char* argv[]) {
	radio_button_id=(char**)calloc(1,sizeof(char*));

    yyin = fopen(argv[1], "r");

    if (yyin == NULL) {
        printf("%s: File not found\n", argv[1]);
        return 1;
    }
		yyparse();
		if(errors==0){
		printf("XML file compiled successfully with %d errors!\n", errors);
		}

    fclose(yyin);

	return 0;
}
