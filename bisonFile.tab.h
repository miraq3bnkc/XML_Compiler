/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

#ifndef YY_YY_BISONFILE_TAB_H_INCLUDED
# define YY_YY_BISONFILE_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    T_EOF = 0,                     /* T_EOF  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    INT = 258,                     /* "int"  */
    STRING = 259,                  /* STRING  */
    MATCH_PARENT = 260,            /* "match_parent"  */
    WRAP_CONTENT = 261,            /* "wrap_content"  */
    ASSIGN = 262,                  /* "="  */
    START_TAG = 263,               /* "<"  */
    SMALL_CLOSETAG = 264,          /* "/>"  */
    ENDTAG = 265,                  /* ">"  */
    CLOSETAG = 266,                /* "</"  */
    LAYOUT_1 = 267,                /* LAYOUT_1  */
    LAYOUT_2 = 268,                /* LAYOUT_2  */
    RGROUP = 269,                  /* RGROUP  */
    TEXTVIEW = 270,                /* TEXTVIEW  */
    IMAGEVIEW = 271,               /* IMAGEVIEW  */
    BUTTON = 272,                  /* BUTTON  */
    RBUTTON = 273,                 /* RBUTTON  */
    PROGRESSBAR = 274,             /* PROGRESSBAR  */
    ANDROIDTAG = 275,              /* ANDROIDTAG  */
    WIDTH = 276,                   /* WIDTH  */
    HEIGHT = 277,                  /* HEIGHT  */
    ID = 278,                      /* ID  */
    ORIENTATION = 279,             /* ORIENTATION  */
    VERTICAL = 280,                /* VERTICAL  */
    HORIZONTAL = 281,              /* HORIZONTAL  */
    TEXT = 282,                    /* TEXT  */
    TEXTCOLOR = 283,               /* TEXTCOLOR  */
    SOURCE = 284,                  /* SOURCE  */
    PADDING = 285,                 /* PADDING  */
    CHECK_B = 286,                 /* CHECK_B  */
    MAX = 287,                     /* MAX  */
    PROGRESS = 288                 /* PROGRESS  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 17 "bisonFile.y"

	int integer;

#line 101 "bisonFile.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_BISONFILE_TAB_H_INCLUDED  */
