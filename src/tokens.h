/* A Bison parser, made by GNU Bison 2.3.  */

/* Skeleton interface for Bison's Yacc-like parsers in C

   Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02110-1301, USA.  */

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

/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     IDF = 258,
     INT = 259,
     DOUBLE = 260,
     REAL = 261,
     FLOAT = 262,
     CHAR = 263,
     QUOTE = 264,
     DQUOTE = 265,
     LE = 266,
     GE = 267,
     EQ = 268,
     NE = 269,
     AND = 270,
     OR = 271,
     NOT = 272,
     IF = 273,
     THEN = 274,
     ELSE = 275,
     WHILE = 276,
     INT_LIT = 277,
     F_LIT = 278,
     END = 279,
     TRUE = 280,
     FALSE = 281,
     FOR = 282,
     NEXT = 283,
     REPEAT = 284,
     UNTIL = 285,
     CASE = 286,
     CONST = 287
   };
#endif
/* Tokens.  */
#define IDF 258
#define INT 259
#define DOUBLE 260
#define REAL 261
#define FLOAT 262
#define CHAR 263
#define QUOTE 264
#define DQUOTE 265
#define LE 266
#define GE 267
#define EQ 268
#define NE 269
#define AND 270
#define OR 271
#define NOT 272
#define IF 273
#define THEN 274
#define ELSE 275
#define WHILE 276
#define INT_LIT 277
#define F_LIT 278
#define END 279
#define TRUE 280
#define FALSE 281
#define FOR 282
#define NEXT 283
#define REPEAT 284
#define UNTIL 285
#define CASE 286
#define CONST 287




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
#line 15 "pico.y"
{
    char* cadeia;
    struct _node * no;
}
/* Line 1529 of yacc.c.  */
#line 118 "y.tab.h"
	YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif

extern YYSTYPE yylval;

