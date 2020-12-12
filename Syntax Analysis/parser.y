%{

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

extern FILE* yyin;
extern int yylex();
extern int yylineno;

// Πρέπει να κάνουμε define την yyerror για να τρέξει.
extern void yyerror(const char* err) {
  fprintf(stderr, "[Line: %03d] Error: %s\n", yylineno, err);
}

%}

%define parse.error verbose

%union {
  int integer;
  double real;
  // TODO: CHANGE TO BOOL.
  int logical;
  char character;
  const char* string;
}

  /* ΛΕΞΕΙΣ ΚΛΕΙΔΙΑ */
%token T_FUNCTION    1 "function"
%token T_SUBROUTINE  2 "subroutine"
%token T_END         3 "end"
%token T_INTEGER     4 "integer"
%token T_REAL        5 "real"
%token T_LOGICAL     6 "logical"
%token T_CHARACTER   7 "character"
%token T_RECORD      8 "record"
%token T_ENDREC      9 "endrec"
%token T_DATA       10 "data"
%token T_CONTINUE   11 "continue"
%token T_GOTO       12 "goto"
%token T_CALL       13 "call"
%token T_READ       14 "read"
%token T_WRITE      15 "write"
%token T_IF         16 "if"
%token T_THEN       17 "then"
%token T_ELSE       18 "else"
%token T_ENDIF      19 "endif"
%token T_DO         20 "do"
%token T_ENDDO      21 "enddo"
%token T_STOP       22 "stop"
%token T_RETURN     23 "return"
%token T_ID         24 "id"

  /* ΣΤΑΘΕΡΕΣ */
%token <integer>   T_ICONST 25 "iconst"
%token <real>      T_RCONST 26 "rconst"
%token <logical>   T_LCONST 27 "lconst"
%token <character> T_CCONST 28 "cconst"

  /* ΛΟΓΙΚΟΙ ΤΕΛΕΣΤΕΣ */
%token T_OROP       29 ".or."
%token T_ANDOP      30 ".and."
%token T_NOTOP      31 ".not."
%token T_RELOP      32 ".gt. .ge. .lt. .le. .eq. .ne."
%token T_ADDOP      33 "+ -"
%token T_MULOP      34 "*"
%token T_DIVOP      35 "/"
%token T_POWEROP    36 "**"

%token <string>   T_STRING 37 "string"

  /* ΑΛΛΕΣ ΛΕΚΤΙΚΕΣ ΜΟΝΑΔΕΣ */
%token T_LPAREN     38 "("
%token T_RPAREN     39 ")"
%token T_COMMA      40 ","
%token T_ASSIGN     41 "="
%token T_COLON      42 ":"

%token T_EOF      0 "<EOF>"

%%

program             : body T_END subprograms

body                : declarations statements

declarations        : declarations type vars
                    | declarations T_RECORD fields T_ENDREC vars
                    | declarations T_DATA vals
                    | %empty

type                : T_INTEGER | T_REAL | T_LOGICAL | T_CHARACTER

vars                : vars T_COMMA undef_variable
                    | undef_variable

undef_variable      : T_ID T_LPAREN dims T_RPAREN
                    | T_ID

dims                : dims T_COMMA dim
                    | dim

dim                 : T_ICONST | T_ID

fields              : fields field
                    | field

field               : type vars
                    | T_RECORD fields T_ENDREC vars

vals                : vals T_COMMA T_ID value_list
                    | T_ID value_list

value_list          : T_DIVOP values T_DIVOP

values              : values T_COMMA value
                    | value

value               : repeat T_MULOP T_ADDOP constant
                    | repeat T_MULOP constant
                    | repeat T_MULOP T_STRING
                    | T_ADDOP constant
                    | constant
                    | T_STRING

repeat              : T_ICONST | %empty

constant            : T_ICONST | T_RCONST | T_LCONST | T_CCONST

statements          : statements labeled_statement
                    | labeled_statement

labeled_statement   : label statement
                    | statement

label               : T_ICONST

statement           : simple_statement
                    | compound_statement

simple_statement    : assignment
                    | goto_statement
                    | if_statement
                    | subroutine_call
                    | io_statement
                    | T_CONTINUE
                    | T_RETURN
                    | T_STOP

assignment          : variable T_ASSIGN expression
                    | variable T_ASSIGN T_STRING

variable            : variable T_COLON T_ID
                    | variable T_LPAREN expressions T_RPAREN
                    | T_ID

expressions         : expressions T_COMMA expression
                    | expression

expression          : expression T_OROP expression
                    | expression T_ANDOP expression
                    | expression T_RELOP expression
                    | expression T_ADDOP expression
                    | expression T_MULOP expression
                    | expression T_DIVOP expression
                    | expression T_POWEROP expression
                    | T_NOTOP expression
                    | T_ADDOP expression
                    | variable
                    | constant
                    | T_LPAREN expression T_RPAREN

goto_statement      : T_GOTO label
                    | T_GOTO T_ID T_COMMA T_LPAREN labels T_RPAREN

labels              : labels T_COMMA label
                    | label

if_statement        : T_IF T_LPAREN expression T_RPAREN label T_COMMA label T_COMMA label
                    | T_IF T_LPAREN expression T_RPAREN simple_statement

subroutine_call     : T_CALL variable

io_statement        : T_READ read_list
                    | T_WRITE write_list

read_list           : read_list T_COMMA read_item
                    | read_item
                    
read_item           : variable
                    | T_LPAREN read_list T_COMMA T_ID T_ASSIGN iter_space T_RPAREN

iter_space          : expression T_COMMA expression step

step                : T_COMMA expression
                    | %empty

write_list          : write_list T_COMMA write_item
                    | write_item

write_item          : expression
                    | T_LPAREN write_list T_COMMA T_ID T_ASSIGN iter_space T_RPAREN
                    | T_STRING

compound_statement  : branch_statement
                    | loop_statement

branch_statement    : T_IF T_LPAREN expression T_RPAREN T_THEN body tail

tail                : T_ELSE body T_ENDIF
                    | T_ENDIF

loop_statement      : T_DO T_ID T_ASSIGN iter_space body T_ENDDO

subprograms         : subprograms subprogram
                    | %empty

subprogram          : header body T_END

header              : type T_FUNCTION T_ID T_LPAREN formal_parameters T_RPAREN
                    | T_SUBROUTINE T_ID T_LPAREN formal_parameters T_RPAREN
                    | T_SUBROUTINE T_ID

formal_parameters   : type vars T_COMMA formal_parameters
                    | type vars

%%

int main(int argc, char** argv) {
  if (argc < 2) {
    printf("MISSING FILE.\n");
    return EXIT_FAILURE;
  }

  yyin = fopen(argv[1], "r");
  if (yyin == NULL) {
    perror("[ERROR] Could not open file");
    return EXIT_FAILURE;
  }

  yyparse();
  fclose(yyin);
  return 0;
}
