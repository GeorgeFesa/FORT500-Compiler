%{ 

#include "tokens.h"
#include "lexer_util.h"
#include "parser.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <math.h>

#define FLEX_DEBUG

struct string_buffer buff;
int errors = 0;

%}

%option noyywrap
%option case-insensitive
%option yylineno

%x STRING
%x COMMENT

WHITESPACE    [ \t\r\n\f]

IDENTIFIER    (_[a-zA-Z]([a-zA-Z0-9]*_?[a-zA-Z0-9]+)*_)|([a-zA-Z][a-zA-Z0-9]*)

DECIMAL       [1-9][0-9]*
HEXADECIMAL   0[Hh][1-9a-fA-F][0-9a-fA-F]*
BINARY        0[Bb]1[01]*
ICONST        {DECIMAL}|{HEXADECIMAL}|{BINARY}|0

RCONST1       (0|([1-9][0-9]*))?\.(0|[0-9]*[1-9][0-9]*)
RCONST2       (0|([1-9][0-9]*))(\.(0|[0-9][1-9][0-9]*)?)?
EXPONENT      [Ee][+-]?(0|([1-9][0-9]*))
R_HEXADECIMAL 0[Hh](0|([1-9a-fA-F][0-9a-fA-F]*))\.(([0-9a-fA-F]*[1-9a-fA-F][0-9a-fA-F]*)|0)?
R_BINARY      0[Bb](0|(1[01]*)?)\.(([01]*1[01]*)|0)?
RCONST        ({RCONST1}|{RCONST2}){EXPONENT}?|{R_HEXADECIMAL}|{R_BINARY}

/* 
 * RCONST        (((((0|([1-9][0-9]*)))?\.(0|([1-9][0-9]*)+)|(0|([1-9][0-9]*)+)\.?(0|([1-9][0-9]*)))([Ee][+-]?(0|([1-9][0-9]*)))?)|((0[Hh](0|([1-9a-fA-F][0-9a-fA-F]*))\.(([0-9a-fA-F]*[1-9a-fA-F][0-9a-fA-F]*)|0)?)|(0[Bb](0|(1[01]*))\.(([01]*1[01]*)|0)?)))
 */

CCONST        '((\\[\\nftrbv])|.)'

%%

  /* ΛΕΞΕΙΣ ΚΛΕΙΔΙΑ */
"FUNCTION"               { print_token(T_FUNCTION);   return T_FUNCTION;             }
"SUBROUTINE"             { print_token(T_SUBROUTINE); return T_SUBROUTINE;           }
"END"                    { print_token(T_END);        return T_END;                  }
"INTEGER"                { print_token(T_INTEGER);    return T_INTEGER;              }
"REAL"                   { print_token(T_REAL);       return T_REAL;                 }
"LOGICAL"                { print_token(T_LOGICAL);    return T_LOGICAL;              }
"CHARACTER"              { print_token(T_CHARACTER);  return T_CHARACTER;            }
"RECORD"                 { print_token(T_RECORD);     return T_RECORD;               }
"ENDREC"                 { print_token(T_ENDREC);     return T_ENDREC;               }
"DATA"                   { print_token(T_DATA);       return T_DATA;                 }
"CONTINUE"               { print_token(T_CONTINUE);   return T_CONTINUE;             }
"GOTO"                   { print_token(T_GOTO);       return T_GOTO;                 }
"CALL"                   { print_token(T_CALL);       return T_CALL;                 }
"READ"                   { print_token(T_READ);       return T_READ;                 }
"WRITE"                  { print_token(T_WRITE);      return T_WRITE;                }
"IF"                     { print_token(T_IF);         return T_IF;                   }
"THEN"                   { print_token(T_THEN);       return T_THEN;                 }
"ELSE"                   { print_token(T_ELSE);       return T_ELSE;                 }
"ENDIF"                  { print_token(T_ENDIF);      return T_ENDIF;                }
"DO"                     { print_token(T_DO);         return T_DO;                   }
"ENDDO"                  { print_token(T_ENDDO);      return T_ENDDO;                }
"STOP"                   { print_token(T_STOP);       return T_STOP;                 }
"RETURN"                 { print_token(T_RETURN);     return T_RETURN;               }

  /* STRINGS - Υπο-αναλυτής */
\"                       { strcpy(buff.string, "");   BEGIN(STRING);                 }
<STRING>\"               { BEGIN(INITIAL);
                           print_token(T_STRING); 
                           yylval.string = strdup(buff.string); 
                           return T_STRING;                                          }
<STRING>(\\\n|\\\r\n)    {                                                           }
<STRING>(\\.|[^"\\])     { string_buffer_concat_string(&buff, yytext);               } 
<STRING>(\n|\r\n)        { print_error("String: Newline found without \\.");         } /* ERROR */
<STRING><<EOF>>          { print_error("String: End of string without closing it."); } /* ERROR */
<STRING>.                { print_error("String: Unknown character.");                } /* ERROR */

  /* ΣΧΟΛΙΑ */
"$"                      { BEGIN(COMMENT);                                           }
<COMMENT>(\n|\r\n)       { BEGIN(INITIAL);                                           }
<COMMENT>.               {                                                           }

  /* ΛΟΓΙΚΕΣ ΣΤΑΘΕΡΕΣ */
"\.TRUE\."|"\.FALSE\."   { print_token(T_LCONST);     return T_LCONST;               }
  
  /* ΤΕΛΕΣΤΕΣ */
"\.OR\."                 { print_token(T_OROP);       return T_OROP;                 }
"\.AND\."                { print_token(T_ANDOP);      return T_ANDOP;                }
"\.NOT\."                { print_token(T_NOTOP);      return T_NOTOP;                }
"\.GT\."|"\.GE\."|"\.LT\."|"\.LE\."|"\.EQ\."|"\.NE\." {   
                           print_token(T_RELOP);      return T_RELOP;                }
"+"|"-"                  { print_token(T_ADDOP);      return T_ADDOP;                }
"*"                      { print_token(T_MULOP);      return T_MULOP;                }
"/"                      { print_token(T_DIVOP);      return T_DIVOP;                }
"**"                     { print_token(T_POWEROP);    return T_POWEROP;              }
  
  /* ΑΛΛΕΣ ΛΕΚΤΙΚΕΣ ΜΟΝΑΔΕΣ */
"("                      { print_token(T_LPAREN);     return T_LPAREN;               }
")"                      { print_token(T_RPAREN);     return T_RPAREN;               }
","                      { print_token(T_COMMA);      return T_COMMA;                }
"="                      { print_token(T_ASSIGN);     return T_ASSIGN;               }
":"                      { print_token(T_COLON);      return T_COLON;                }

{IDENTIFIER}             { print_token(T_ID); 
                           yylval.string = strdup(yytext);
                           return T_ID; }
  
  /* ΣΤΑΘΕΡΕΣ */
{ICONST}                 { print_token(T_ICONST); 
                           yylval.integer = str_to_int(yytext);
                           return T_ICONST; }
{RCONST}                 { print_token(T_RCONST);
                           yylval.real = str_to_double(yytext);
                           return T_RCONST; }
{CCONST}                 { print_token(T_CCONST); 
                           yylval.character = fix_escape_characters();
                           return T_CCONST; }
{WHITESPACE}             {                                                           }

<<EOF>>                  { print_token(T_EOF);        return T_EOF;                  }
.                        { print_error("Unrecognised character!");                   }

%%

/*
int main(int argc, char *argv[]) {
	int token;        

  if (argc < 2) {
    printf("MISSING FILE.\n");
    return EXIT_FAILURE;
  }

  yyin = fopen(argv[1], "r");
  CHECK_ERROR(yyin, "Could not open file."); 

  string_buffer_init(&buff);

	do {		
		token = yylex(); 
	} while (token != T_EOF);

  string_buffer_destroy(&buff);

	fclose(yyin);
	yyterminate();

  return EXIT_SUCCESS;
}
*/

void print_token(int token) {

#ifdef FLEX_DEBUG
  switch (token) {
  case T_ICONST:
    printf("[Line: %03d] INTEGER: (%-12s => %02d) \"%s\", Value: %d\n", yylineno, TOKEN_NAME[token], token, yytext, str_to_int(yytext));
    break;

  case T_RCONST:
    printf("[Line: %03d] REAL:    (%-12s => %02d) \"%s\", Value: %lf\n", yylineno, TOKEN_NAME[token], token, yytext, str_to_double(yytext));
    break;
  
  case T_STRING:
    printf("[Line: %03d] STRING:  \"%s\"\n", yylineno, buff.string);
    break;

  default:
    printf("[Line: %03d] TOKEN:   (%-12s => %02d) \"%s\"\n", yylineno, TOKEN_NAME[token], token, yytext);
    break;
  }
#else
  return;
#endif

}

void print_error(const char* error_msg) {
  ++errors;
  printf("[Line: %03d] ERROR:   %s  %s\n", yylineno, error_msg, yytext);

  if (errors == 5) {
    printf("Maximum number of errors.\n");
    exit(EXIT_FAILURE);
  }

  yyless(1); /* Panic Method */
}
