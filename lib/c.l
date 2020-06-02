%{
#include <stdio.h>
#include "c.tab.h"
void buildWordAnalysisTable(float);
void printAnalysedWord(float);
%}

%%
"main" {
  printAnalysedWord(1);
  buildWordAnalysisTable(1);
  return MainDeclaration;
}

"int" {
  printAnalysedWord(2);
  buildWordAnalysisTable(2);
  return VarDeclaration;
}

"<"|">"|"!="|">="|"<="|"==" {
  printAnalysedWord(3);
  buildWordAnalysisTable(3);
  return RelationOperator;
}

"if" {
  printAnalysedWord(4);
  buildWordAnalysisTable(4);
  return IfStatement;
}

"else" {
  printAnalysedWord(5);
  buildWordAnalysisTable(5);
  return ElseStatement;
}

"while" {
  printAnalysedWord(6);
  buildWordAnalysisTable(6);
  return WhileStatement;
}

"do" {
  printAnalysedWord(7);
  buildWordAnalysisTable(7);
  return DoStatement;
}

"+"|"-" {
  printAnalysedWord(8);
  buildWordAnalysisTable(8);
  return AddOperator;
}

"*"|"/" {
  printAnalysedWord(9);
  buildWordAnalysisTable(9);
  return MultiplyOperator;
}

[a-zA-Z] {
  printAnalysedWord(10);
  buildWordAnalysisTable(10);
  yylval.char_type = yytext[0];
  return Letter;
}

[0-9] {
  printAnalysedWord(11);
  buildWordAnalysisTable(11);
  yylval.int_type = atoi(yytext);
  return Number;
}

","|";"|"="|"{"|"}"|"("|")" {
  printAnalysedWord(12);
  buildWordAnalysisTable(12);
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

void buildWordAnalysisTable(float typeCode) {
  FILE* fp;
  fp = fopen("build/word_analysis_result", "a");
  fprintf(fp, "|%-5d|%-5s|%-5.1f|\n", yylineno, yytext, typeCode);
  fclose(fp);
}

void printAnalysedWord(float typeCode) {
  printf("|%-5d|%-5s|%-5.1f|\n", yylineno, yytext, typeCode);
}
