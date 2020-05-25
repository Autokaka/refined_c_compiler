%{
#include <stdio.h>
#include "y.tab.h"
%}

%%
"main"" "*"("" "*")" {
  return MainDeclaration;
}
"int" {
  return VarDeclaration;
}
"<"|">"|"!="|">="|"<="|"==" {
  return RelationOperator;
}
"if" {
  return IfStatement;
}
"else" {
  return ElseStatement;
}
"while" {
  return WhileStatement;
}
"do" {
  return DoStatement;
}
[a-zA-Z] {
  return Letter;
}
"+"|"-" {
  return AddOperator;
}
"*"|"/" {
  return MultiplyOperator;
}
[0-9] {
  return Number;
}
[ \t\n] {/* ignore symbols */}
. {
  printf("unanalysed charactor: %s\n", yytext);
  return yytext[0];
}
%%

int yywrap(void) {
  return 1;
}
