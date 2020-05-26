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

"+"|"-" {
  return AddOperator;
}

"*"|"/" {
  return MultiplyOperator;
}

[a-zA-Z] {
  yylval.char_type = yytext[0];
  return Letter;
}

[0-9]+ {
  yylval.int_type = atoi(yytext);
  return Number;
}

","|";"|"="|"{"|"}"|"("|")" {
  printf("scanning symbol: %c\n", yytext[0]);
  return yytext[0];
}

[ \t\n\r\f\v] {/* ignore symbols */}

. {
  printf("unexpected charactor: %c\n", yytext[0]);
}
%%

int yywrap(void) {
  return 1;
}
