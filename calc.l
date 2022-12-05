%option noyywrap

%{
#include <stdio.h>

#define YY_DECL int yylex()

#include "calc.tab.h"
#include "helpers.h"

%}

%%

[ \t]	; // ignore all whitespace
\n		{return T_NEWLINE;}
"+"|"su'i"		{return T_PLUS;}
"-"|"vu'u"		{return T_MINUS;}
"*"|"pi'i"		{return T_MULTIPLY;}
"/"|"fe'i"		{return T_DIVIDE;}
"("		{return T_LEFT;}
")"		{return T_RIGHT;}
"dicra"		{return T_QUIT;}
[a-z]+		{yylval.ival = convert(yytext); return T_INT;}

%%

