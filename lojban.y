%{
#include <alloca.h>
#include <math.h>
#include <stdlib.h>
#include <stddef.h>
#include <ctype.h>
#define YYSTYPE double
double calcfact();
double reg[99];
double ans;
char format[20];
%}

%token NUMBER SPACE MOD RIGHTSHIFT LEFTSHIFT SEMICOLON SIN EOLN PIVAL
%token PLUS MINUS DIV MUL POW OPENBRACKET CLOSEBRACKET UNARYMINUS
%token COS TAN ASIN ACOS ATAN FACT INC DEC LAND OR COMPLEMENT
%token NOT XOR ASSIGN IOR AND OPENREG CLOSEREG REGA ANS FIX SCI ENG
%token CONST
%left PLUS MINUS
%left MUL DIV
%left UNARYMINUS
%left LAND OR XOR NOT AND IOR
%left LOG

%%


list:   // nothing
        |list EOLN
        | list expr EOLN
          { printf( format , (double) $2 ); ans=$2; }
        ;
expr:   conditional_expr
        ;
conditional_expr: logical_or_expr
        ;
logical_or_expr: logical_and_expr
        | logical_or_expr OR logical_and_expr
          { $$ = (int) $1 || (int) $3; }
        ;
logical_and_expr: inclusive_or_expr
        | logical_and_expr LAND inclusive_or_expr
          { $$ = (int) $1 && (int) $3; }
        ;
inclusive_or_expr: exclusive_or_expr
        | inclusive_or_expr IOR exclusive_or_expr
          { $$ = (int) $1 | (int) $3; }
        ;
exclusive_or_expr: and_expr
        | exclusive_or_expr XOR and_expr
          { $$ = (int) $1 ^ (int) $3; }
        ;
and_expr: shift_expr
        | and_expr AND shift_expr
          { $$ = (int) $1 & (int) $3; }
        ;
shift_expr: pow_expr
        | shift_expr LEFTSHIFT pow_expr
          { $$ = (int) $1 << (int) $3; }
        | shift_expr RIGHTSHIFT pow_expr
          { $$ = (int) $1 >>(int) $3; }
        ;
pow_expr: add_expr
        | pow_expr POW add_expr { $$ = pow($1,$3); }
        ;
add_expr: mul_expr
        | add_expr PLUS mul_expr  { $$ = $1 + $3; }
        | add_expr MINUS mul_expr { $$ = $1 ‑ $3; }
        ;
mul_expr: unary_expr
        | mul_expr MUL unary_expr { $$ = $1 ∗ $3; }
        | mul_expr DIV unary_expr { $$ = $1 / $3; }
        | mul_expr MOD unary_expr { $$ = fmod($1,$3); }
        ;
unary_expr: assign_expr
        | MINUS primary %prec UNARYMINUS { $$ = ‑$2; }
        | INC unary_expr { $$ = $2+1; }
        | DEC unary_expr { $$ = $2‑1; }
        | NOT unary_expr { $$ = !$2; }
        | LOG unary_expr { $$ = log($2); }
        ;
assign_expr: postfix_expr
        | REGA OPENREG expr CLOSEREG ASSIGN postfix_expr
          { reg[(int)$3]=$6; $$=$6; }
        | REGA OPENREG expr CLOSEREG
          { $$=reg[(int)$3]; }
        | REGA
          { int i;
            for(i=0;i<100;i++)
              if (reg[i]!=0)
                printf("%02d = %.2f\n",i,reg[i]);
            $$=0;
          }
        ;
postfix_expr: primary
        | postfix_expr INC { $$ = $1+1; }
        | postfix_expr DEC { $$ = $1‑1; }
        | postfix_expr FACT
          { $$ = calcfact((unsigned long int)$1); }
        ;
 primary: NUMBER { $$ = $1; }
        | PIVAL { $$ = M_PI; }
        | OPENBRACKET expr CLOSEBRACKET { $$ = $2; }
        | ANS { $$ = ans; }
        | CONST OPENBRACKET expr CLOSEBRACKET { $$ = constval($3); }
        | set_format
        ;
set_format: function_call
        | FIX OPENBRACKET expr CLOSEBRACKET
              { sprintf(format,".%df\n",(int)$3); $$=0
              ; }
        | FIX { sprintf(format,"f\n"); $$=0
        ; }
        | SCI OPENBRACKET expr CLOSEBRACKET
              { sprintf(format,".%dg\n",(int)$3); $$=0
              ; }
        | SCI { sprintf(format,"g\n"); $$=0
        ; }
        | ENG OPENBRACKET expr CLOSEBRACKET
              { sprintf(format,".%de\n",(int)$3); $$=0
              ; }
        | ENG { sprintf(format,"e\n"); $$=0
        ; }
        ;
function_call: SIN OPENBRACKET expr CLOSEBRACKET
               { $$ = (cos($3)∗tan($3)); }
        | COS OPENBRACKET expr CLOSEBRACKET
               { $$ = cos($3); }
        | TAN OPENBRACKET expr CLOSEBRACKET
               { $$ = tan($3); }
        | ASIN OPENBRACKET expr CLOSEBRACKET
               { $$ = asin($3); }
        | ACOS OPENBRACKET expr CLOSEBRACKET
               { $$ = acos($3); }
        | ATAN OPENBRACKET expr CLOSEBRACKET
               { $$ = atan($3); }
        ;

%%

#include <stdio.h>
#include <ctype.h>
char ∗progname;
double yylval;

main( argc, argv )
char ∗argv[];
{
  progname = argv[0];
  strcpy(format,"%g\n");
  yyparse();
}

yyerror( s )
char ∗s;
{
  warning( s , ( char ∗ )0 );
  yyparse();
}

warning( s , t )
char ∗s , ∗t;
{
  fprintf( stderr ,"%s: %s\n" , progname , s );
  if ( t )
    fprintf( stderr , " %s\n" , t );
}