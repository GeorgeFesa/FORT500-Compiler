/* A Bison parser, made by GNU Bison 3.5.1.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2020 Free Software Foundation,
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
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

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

/* Undocumented macros, especially those whose name start with YY_,
   are private implementation details.  Do not rely on them.  */

#ifndef YY_YY_PARSER_TAB_H_INCLUDED
# define YY_YY_PARSER_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    T_EOF = 0,
    T_FUNCTION = 1,
    T_SUBROUTINE = 2,
    T_END = 3,
    T_INTEGER = 4,
    T_REAL = 5,
    T_LOGICAL = 6,
    T_CHARACTER = 7,
    T_RECORD = 8,
    T_ENDREC = 9,
    T_DATA = 10,
    T_CONTINUE = 11,
    T_GOTO = 12,
    T_CALL = 13,
    T_READ = 14,
    T_WRITE = 15,
    T_IF = 16,
    T_THEN = 17,
    T_ELSE = 18,
    T_ENDIF = 19,
    T_DO = 20,
    T_ENDDO = 21,
    T_STOP = 22,
    T_RETURN = 23,
    T_ID = 24,
    T_ICONST = 25,
    T_RCONST = 26,
    T_LCONST = 27,
    T_CCONST = 28,
    T_OROP = 29,
    T_ANDOP = 30,
    T_NOTOP = 31,
    T_RELOP = 32,
    T_ADDOP = 33,
    T_MULOP = 34,
    T_DIVOP = 35,
    T_POWEROP = 36,
    T_STRING = 37,
    T_LPAREN = 38,
    T_RPAREN = 39,
    T_COMMA = 40,
    T_ASSIGN = 41,
    T_COLON = 42
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 26 "parser.y"

  int integer;
  double real;
  // Γιατί όχι bool ???????????????????
  _Bool logical;
  char character;
  const char* string;

#line 112 "parser.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_PARSER_TAB_H_INCLUDED  */
