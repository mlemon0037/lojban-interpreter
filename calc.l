%option noyywrap

%{
#include <stdio.h>

#define YY_DECL int yylex()

#include "calc.tab.h"
#include "helpers.h"

%}

%%

[ \t]	; // ignore all whitespace
\n		{return NEWLINE;}
"+"|"su'i"		{return PLUS;}
"-"|"vu'u"		{return MINUS;}
"*"|"pi'i"		{return MULTIPLY;}
"/"|"fe'i"		{return DIVIDE;}
"("		{return LEFT;}
")"		{return RIGHT;}
"dicra"		{return QUIT;}
[a-z]+		{yylval.ival = convert(yytext); return INT;}

%%

