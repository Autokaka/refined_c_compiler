%{
#include <stdio.h>
#include "c.tab.h"
void buildWordAnalysisTable(int);
void printWordAnalysis(int);

// extra configs
int showWordAnalysis = 0;
%}

%%
"main" {
  printWordAnalysis(1);
  buildWordAnalysisTable(1);
  yylval.str_type = strdup(yytext);
  return MainDeclaration;
}

"int" {
  printWordAnalysis(2);
  buildWordAnalysisTable(2);
  yylval.str_type = strdup(yytext);
  return VarDeclaration;
}

"<"|">"|"!="|">="|"<="|"==" {
  printWordAnalysis(3);
  buildWordAnalysisTable(3);
  yylval.str_type = strdup(yytext);
  return RelationOperator;
}

"if" {
  printWordAnalysis(4);
  buildWordAnalysisTable(4);
  yylval.str_type = strdup(yytext);
  return IfStatement;
}

"else" {
  printWordAnalysis(5);
  buildWordAnalysisTable(5);
  yylval.str_type = strdup(yytext);
  return ElseStatement;
}

"while" {
  printWordAnalysis(6);
  buildWordAnalysisTable(6);
  yylval.str_type = strdup(yytext);
  return WhileStatement;
}

"do" {
  printWordAnalysis(7);
  buildWordAnalysisTable(7);
  yylval.str_type = strdup(yytext);
  return DoStatement;
}

"+"|"-" {
  printWordAnalysis(8);
  buildWordAnalysisTable(8);
  yylval.char_type = yytext[0];
  return AddOperator;
}

"*"|"/" {
  printWordAnalysis(9);
  buildWordAnalysisTable(9);
  yylval.char_type = yytext[0];
  return MultiplyOperator;
}

[a-zA-Z] {
  printWordAnalysis(10);
  buildWordAnalysisTable(10);
  yylval.char_type = yytext[0];
  return Letter;
}

[0-9] {
  printWordAnalysis(11);
  buildWordAnalysisTable(11);
  yylval.int_type = atoi(yytext);
  return Number;
}

","|";"|"="|"{"|"}"|"("|")" {
  printWordAnalysis(12);
  buildWordAnalysisTable(12);
  yylval.char_type = yytext[0];
  return yytext[0];
}

[ \t\f\v] {
  /* ignore symbols */
}

[\n\r] {
  yylineno++;
}

. {
  printf("\033[31munexpected charactor: %c\033[0m\n", yytext[0]);
  yylval.char_type = yytext[0];
}
%%

int yywrap(void) {
  return 1;
}

void buildWordAnalysisTable(int typeCode) {
  FILE* fp;
  fp = fopen("build/word_analysis_table", "a");
  fprintf(fp, "|%-8d|%-8s|%-8d|\n", yylineno, yytext, typeCode);
  fclose(fp);
}

void printWordAnalysis(int typeCode) {
  if (!showWordAnalysis) return;
  printf("|%-8d|%-8s|%-8d|\n", yylineno, yytext, typeCode);
}
