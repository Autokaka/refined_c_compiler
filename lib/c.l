%{
#include <stdio.h>
#include "c.tab.h"
%}

%%
"main" {
  printf("MainDeclaration: %s\n", yytext);
  return MainDeclaration;
}

"int" {
  printf("VarDeclaration: %s\n", yytext);
  return VarDeclaration;
}

"<"|">"|"!="|">="|"<="|"==" {
  printf("RelationOperator: %s\n", yytext);
  return RelationOperator;
}

"if" {
  printf("IfStatement: %s\n", yytext);
  return IfStatement;
}

"else" {
  printf("ElseStatement: %s\n", yytext);
  return ElseStatement;
}

"while" {
  printf("WhileStatement: %s\n", yytext);
  return WhileStatement;
}

"do" {
  printf("DoStatement: %s\n", yytext);
  return DoStatement;
}

"+"|"-" {
  printf("AddOperator: %c\n", yytext[0]);
  return AddOperator;
}

"*"|"/" {
  printf("MultiplyOperator: %c\n", yytext[0]);
  return MultiplyOperator;
}

[a-zA-Z] {
  printf("Letter: %c\n", yytext[0]);
  yylval.char_type = yytext[0];
  return Letter;
}

[0-9] {
  printf("Number: %d\n", atoi(yytext));
  yylval.int_type = atoi(yytext);
  return Number;
}

","|";"|"="|"{"|"}"|"("|")" {
  printf("NormalSymbol: %c\n", yytext[0]);
  return yytext[0];
}

[ \t\f\v] {/* ignore symbols */}

[\n\r] {
  yylineno++;
}

. {
  printf("\033[31munexpected charactor: %c\033[0m\n", yytext[0]);
}
%%

int yywrap(void) {
  return 1;
}
