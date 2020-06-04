%{
#include <stdio.h>
#include <math.h>
#include <string.h>

#define BUFFER_SIZE 512

extern int yylineno;
extern char *yytext;

int yylex(void);
int yyerror(const char *s);

void buildGrammarAnalysisStack(const char *);
void printGrammarAnalysis(const char *);

void assembleSemanticAnalysisTable(const char *, const char *, const char *, const char *);
void buildSemanticAnalysisTable();
void printSemanticAnalysis();
void prepareSemanticAnalysis();
char* semanticAnalysisTable[BUFFER_SIZE][5];
int semanticAnalysisP;
char* symbols[BUFFER_SIZE];
int symbolsP;

char* itoa(int);
char* ctoa(char);

// extra debug configs
int showGrammarAnalysis = 0;
int showSemanticAnalysis = 0;
%}

/* 类型 */
%union {
  int int_type; 
  char char_type;
  char *str_type;
}

/* 优先级 */
%left '+' '-'
%left '*' '/'

/* 终结符 */
%token <str_type>   MainDeclaration     // main()
%token <str_type>   VarDeclaration      // int
%token <str_type>   RelationOperator    // <|>|!=|>=|<=|==
%token <str_type>   IfStatement         // if
%token <str_type>   ElseStatement       // else
%token <str_type>   WhileStatement      // while
%token <str_type>   DoStatement         // do
%token <char_type>  Letter              // a|b|c...
%token <char_type>  AddOperator         // +|-
%token <char_type>  MultiplyOperator    // *|/
%token <int_type>   Number              // 0|1|2|3|4...

/* 非终结符 */
%start Program
%type <str_type> Program
%type <str_type> SubProgram
%type <str_type> VarDeclarationPart 
%type <str_type> SentencePart
%type <str_type> SubSentencePart
%type <str_type> Sentence
%type <str_type> Sentence1
%type <str_type> ComplexSentence
%type <str_type> IdentifierTable
%type <str_type> SubIdentifierTable
%type <str_type> Identifier
%type <str_type> AssignSentence
%type <str_type> ConditionSentence
%type <str_type> LoopSentence
%type <str_type> Expression
%type <str_type> SubExpression
%type <str_type> Condition
%type <str_type> Term
%type <str_type> SubTerm
%type <str_type> Factor
%type <str_type> ConstValue
%type <str_type> UnsignedInteger
%type <str_type> NumberSequence
%type <str_type> SubNumberSequence

%%
Program: MainDeclaration '(' ')' '{' SubProgram '}' {
  char s[BUFFER_SIZE];
  sprintf(s, "%s(){%s}", $1, $5);
  $$ = strdup(s);

  char *str = "Program => MainDeclaration { SubProgram }";
  buildGrammarAnalysisStack(str);
  printGrammarAnalysis(str);
}

SubProgram: VarDeclarationPart ';' SentencePart {
  char s[BUFFER_SIZE];
  sprintf(s, "%s;%s", $1, $3);
  $$ = strdup(s);

  char *str = "SubProgram => VarDeclarationPart ; SentencePart";
  buildGrammarAnalysisStack(str);
  printGrammarAnalysis(str);
} | {
  $$ = strdup("");

  char *str = "SubProgram => ε";
  buildGrammarAnalysisStack(str);
  printGrammarAnalysis(str);
}

VarDeclarationPart: VarDeclaration IdentifierTable {
  char s[BUFFER_SIZE];
  sprintf(s, "%s%s", $1, $2);
  $$ = strdup(s);

  char *str = "VarDeclarationPart => VarDeclaration IdentifierTable";
  buildGrammarAnalysisStack(str);
  printGrammarAnalysis(str);
}

IdentifierTable: Identifier SubIdentifierTable {
  char s[BUFFER_SIZE];
  sprintf(s, "%s%s", $1, $2);
  $$ = strdup(s);

  char *str = "IdentifierTable => Identifier SubIdentifierTable";
  buildGrammarAnalysisStack(str);
  printGrammarAnalysis(str);
}

SubIdentifierTable: ',' Identifier SubIdentifierTable {
  char s[BUFFER_SIZE];
  sprintf(s, ",%s%s", $2, $3);
  $$ = strdup(s);

  char *str = "SubIdentifierTable => , Identifier SubIdentifierTable";
  buildGrammarAnalysisStack(str);
  printGrammarAnalysis(str);
} | {
  $$ = strdup("");

  char *str = "SubIdentifierTable => ε";
  buildGrammarAnalysisStack(str);
  printGrammarAnalysis(str);
}

Identifier: Letter {
  char s[BUFFER_SIZE];
  sprintf(s, "%c", $1);
  $$ = strdup(s);

  char *str = "Identifier => Letter";
  buildGrammarAnalysisStack(str);
  printGrammarAnalysis(str);
} | Identifier Letter {
  char s[BUFFER_SIZE];
  sprintf(s, "%s%c", $1, $2);
  $$ = strdup(s);

  char *str = "Identifier => Identifier Letter";
  buildGrammarAnalysisStack(str);
  printGrammarAnalysis(str);
} | Identifier Number {
  char s[BUFFER_SIZE];
  sprintf(s, "%s%d", $1, $2);
  $$ = strdup(s);

  char *str = "Identifier => Identifier Number";
  buildGrammarAnalysisStack(str);
  printGrammarAnalysis(str);
}

SentencePart: Sentence SubSentencePart {
  char s[BUFFER_SIZE];
  sprintf(s, "%s%s", $1, $2);
  $$ = strdup(s);

  char *str = "SentencePart => Sentence SubSentencePart";
  buildGrammarAnalysisStack(str);
  printGrammarAnalysis(str);
}

SubSentencePart: ';' Sentence SubSentencePart {
  char s[BUFFER_SIZE];
  sprintf(s, ";%s%s", $2, $3);
  $$ = strdup(s);

  char *str = "SubSentencePart => ; Sentence SubSentencePart";
  buildGrammarAnalysisStack(str);
  printGrammarAnalysis(str);
} | {
  $$ = strdup("");

  char *str = "SubSentencePart => ε";
  buildGrammarAnalysisStack(str);
  printGrammarAnalysis(str);
}

Sentence: AssignSentence {
  char s[BUFFER_SIZE];
  sprintf(s, "%s", $1);
  $$ = strdup(s);

  char *str = "Sentence => AssignSentence";
  buildGrammarAnalysisStack(str);
  printGrammarAnalysis(str);
} | ConditionSentence {
  char s[BUFFER_SIZE];
  sprintf(s, "%s", $1);
  $$ = strdup(s);

  char *str = "Sentence => ConditionSentence";
  buildGrammarAnalysisStack(str);
  printGrammarAnalysis(str);
} | LoopSentence {
  char s[BUFFER_SIZE];
  sprintf(s, "%s", $1);
  $$ = strdup(s);

  char *str = "Sentence => LoopSentence";
  buildGrammarAnalysisStack(str);
  printGrammarAnalysis(str);
} | {
  $$ = strdup("");

  char *str = "Sentence => ε";
  buildGrammarAnalysisStack(str);
  printGrammarAnalysis(str);
}

AssignSentence: Identifier '=' Expression {
  char s[BUFFER_SIZE];
  sprintf(s, "%s=%s", $1, $3);
  $$ = strdup(s);

  char *str = "AssignSentence => Identifier = Expression";
  buildGrammarAnalysisStack(str);
  printGrammarAnalysis(str);

  assembleSemanticAnalysisTable("=", $3, "", $1);
}

Condition: Expression RelationOperator Expression {
  char s[BUFFER_SIZE];
  sprintf(s, "%s%s%s", $1, $2, $3);
  $$ = strdup(s);

  char *str = "Condition => Expression RelationOperator Expression";
  buildGrammarAnalysisStack(str);
  printGrammarAnalysis(str);

  assembleSemanticAnalysisTable($2, $1, $3, itoa(yylineno));
}

Expression: Term SubExpression {
  char s[BUFFER_SIZE];
  sprintf(s, "%s%s", $1, $2);
  $$ = strdup(s);

  char *str = "Expression => Term SubExpression";
  buildGrammarAnalysisStack(str);
  printGrammarAnalysis(str);

  assembleSemanticAnalysisTable("", $1, "", $$);
}

SubExpression: AddOperator Term SubExpression {
  char s[BUFFER_SIZE];
  sprintf(s, "%c%s%s", $1, $2, $3);
  $$ = strdup(s);

  char *str = "SubSxpression => AddOperator Term SubSxpression";
  buildGrammarAnalysisStack(str);
  printGrammarAnalysis(str);

  assembleSemanticAnalysisTable(ctoa($1), "", $2, "");
} | {
  $$ = strdup("");

  char *str = "SubSxpression => ε";
  buildGrammarAnalysisStack(str);
  printGrammarAnalysis(str);
}

Term: Factor SubTerm {
  char s[BUFFER_SIZE];
  sprintf(s, "%s%s", $1, $2);
  $$ = strdup(s);

  char *str = "Term => Factor SubTerm";
  buildGrammarAnalysisStack(str);
  printGrammarAnalysis(str);

  assembleSemanticAnalysisTable("", $1, "", $$);
}

SubTerm: MultiplyOperator Factor SubTerm {
  char s[BUFFER_SIZE];
  sprintf(s, "%c%s%s", $1, $2, $3);
  $$ = strdup(s);

  char *str = "SubTerm => MultiplyOperator Factor Term";
  buildGrammarAnalysisStack(str);
  printGrammarAnalysis(str);

  assembleSemanticAnalysisTable(ctoa($1), "", $2, "");
} | {
  $$ = strdup("");

  char *str = "SubTerm => ε";
  buildGrammarAnalysisStack(str);
  printGrammarAnalysis(str);
}

Factor: Identifier {
  char s[BUFFER_SIZE];
  sprintf(s, "%s", $1);
  $$ = strdup(s);

  char *str = "Factor => Identifier";
  buildGrammarAnalysisStack(str);
  printGrammarAnalysis(str);
} | ConstValue {
  char s[BUFFER_SIZE];
  sprintf(s, "%s", $1);
  $$ = strdup(s);

  char *str = "Factor => ConstValue";
  buildGrammarAnalysisStack(str);
  printGrammarAnalysis(str);
} | '(' Expression ')' {
  char s[BUFFER_SIZE];
  sprintf(s, "(%s)", $2);
  $$ = strdup(s);

  char *str = "Factor => ( Expression )";
  buildGrammarAnalysisStack(str);
  printGrammarAnalysis(str);
}

ConstValue: UnsignedInteger {
  char s[BUFFER_SIZE];
  sprintf(s, "%s", $1);
  $$ = strdup(s);

  char *str = "ConstValue => UnsignedInteger";
  buildGrammarAnalysisStack(str);
  printGrammarAnalysis(str);
}

UnsignedInteger: NumberSequence {
  char s[BUFFER_SIZE];
  sprintf(s, "%s", $1);
  $$ = strdup(s);

  char *str = "UnsignedInteger => NumberSequence";
  buildGrammarAnalysisStack(str);
  printGrammarAnalysis(str);
}

NumberSequence: Number SubNumberSequence {
  char s[BUFFER_SIZE];
  sprintf(s, "%d%s", $1, $2);
  $$ = strdup(s);

  char *str = "NumberSequence => Number SubNumberSequence";
  buildGrammarAnalysisStack(str);
  printGrammarAnalysis(str);
}

SubNumberSequence: Number SubNumberSequence {
  char s[BUFFER_SIZE];
  sprintf(s, "%d%s", $1, $2);
  $$ = strdup(s);

  char *str = "SubNumberSequence => Number SubNumberSequence";
  buildGrammarAnalysisStack(str);
  printGrammarAnalysis(str);
} | {
  $$ = strdup("");

  char *str = "SubNumberSequence => ε";
  buildGrammarAnalysisStack(str);
  printGrammarAnalysis(str);
}

ComplexSentence: '{' SentencePart '}' {
  char s[BUFFER_SIZE];
  sprintf(s, "{%s}", $2);
  $$ = strdup(s);

  char *str = "ComplexSentence => { SentencePart }";
  buildGrammarAnalysisStack(str);
  printGrammarAnalysis(str);
}

Sentence1: Sentence {
  char s[BUFFER_SIZE];
  sprintf(s, "%s", $1);
  $$ = strdup(s);

  char *str = "Sentence1 => Sentence";
  buildGrammarAnalysisStack(str);
  printGrammarAnalysis(str);
} | ComplexSentence {
  char s[BUFFER_SIZE];
  sprintf(s, "%s", $1);
  $$ = strdup(s);

  char *str = "Sentence1 => ComplexSentence";
  buildGrammarAnalysisStack(str);
  printGrammarAnalysis(str);
}

ConditionSentence: IfStatement '(' Condition ')' Sentence1 ElseStatement Sentence1 {
  char s[BUFFER_SIZE];
  sprintf(s, "%s(%s)%s%s%s", $1, $3, $5, $6, $7);
  $$ = strdup(s);

  char *str = "ConditionSentence => IfStatement ( Condition ) Sentence1 ElseStatement Sentence1";
  buildGrammarAnalysisStack(str);
  printGrammarAnalysis(str);
}

LoopSentence: WhileStatement '(' Condition ')' DoStatement Sentence1 {
  char s[BUFFER_SIZE];
  sprintf(s, "%s(%s)%s%s", $1, $3, $5, $6);
  $$ = strdup(s);

  char *str = "LoopSentence => WhileStatement ( Condition ) Sentence1";
  buildGrammarAnalysisStack(str);
  printGrammarAnalysis(str);
}

%%

int main(void) {
  prepareSemanticAnalysis();
  int hasError = yyparse();
  if (hasError) {
    printf("\033[31m///////////////////////////////////////////////////////\033[0m\n");
    printf("\033[31m///////  parse failed: terminated with errors.  ///////\033[0m\n");
    printf("\033[31m///////////////////////////////////////////////////////\033[0m\n");
  } else {
    printSemanticAnalysis();
    buildSemanticAnalysisTable();
    printf("\033[32m//////////////////////////////////////////////////////////\033[0m\n");
    printf("\033[32m///////  0 warnings, 0 errors. Language accepted!  ///////\033[0m\n");
    printf("\033[32m//////////////////////////////////////////////////////////\033[0m\n");
    return 0;
  }
}

int yyerror(const char *s) {
  fprintf(stderr, "\033[31mError: '%s' at line: %d: %s\033[0m\n", yytext, yylineno, s);
	return 1;
}

void buildGrammarAnalysisStack(const char *str) {
  FILE* fp;
  fp = fopen("build/grammar_analysis_stack", "a");
  fprintf(fp, "%s\n", str);
  fclose(fp);
}

void printGrammarAnalysis(const char *str) {
  if (!showGrammarAnalysis) return;
  printf("%s\n", str);
}

void assembleSemanticAnalysisTable(const char *op, const char *arg1, const char *arg2, const char *res) {
  // 读入第一个有效四元式
  if (semanticAnalysisP == 0 && strlen(op) == 0) return;

  if (strlen(op) == 0) {
    if (strlen(semanticAnalysisTable[semanticAnalysisP - 1][2]) > 0) {
      return;
    }
    semanticAnalysisTable[semanticAnalysisP - 1][2] = strdup(arg1);
    semanticAnalysisTable[semanticAnalysisP - 1][4] = strdup(res);
    return;
  }
  semanticAnalysisTable[semanticAnalysisP][0] = itoa(yylineno);
  semanticAnalysisTable[semanticAnalysisP][1] = strdup(op);
  semanticAnalysisTable[semanticAnalysisP][2] = strdup(arg1);
  semanticAnalysisTable[semanticAnalysisP][3] = strdup(arg2);
  semanticAnalysisTable[semanticAnalysisP][4] = strdup(res);
  semanticAnalysisP++;
  if (semanticAnalysisP < 2) return;
  for (int i = 2; i < 4; i++) {
    char *last = semanticAnalysisTable[semanticAnalysisP - 1][i];
    char *current = semanticAnalysisTable[semanticAnalysisP - 2][4];
    if (strcmp(last, current) == 0) {
      semanticAnalysisTable[semanticAnalysisP - 1][i] = symbols[symbolsP];
      semanticAnalysisTable[semanticAnalysisP - 2][4] = symbols[symbolsP];
      symbolsP++;
    }
  }
}

void buildSemanticAnalysisTable() {
  FILE* fp;
  fp = fopen("build/semantic_analysis_table", "a");
  for (int i = 0; i < semanticAnalysisP; i++) {
    fprintf(fp, "%s: (%s, %s, %s, %s)\n",
    semanticAnalysisTable[i][0], 
    semanticAnalysisTable[i][1], 
    semanticAnalysisTable[i][2], 
    semanticAnalysisTable[i][3], 
    semanticAnalysisTable[i][4]);
  }
  fclose(fp);
}

void printSemanticAnalysis() {
  if (!showSemanticAnalysis) return;
  for (int i = 0; i < semanticAnalysisP; i++) {
    printf("%s: (%s, %s, %s, %s)\n",
    semanticAnalysisTable[i][0], 
    semanticAnalysisTable[i][1], 
    semanticAnalysisTable[i][2], 
    semanticAnalysisTable[i][3], 
    semanticAnalysisTable[i][4]);
  }
}

void prepareSemanticAnalysis() {
  semanticAnalysisP = 0;
  for(int i = 0; i < BUFFER_SIZE; i++) {
    for (int j = 0; j < 5; j++) {
      semanticAnalysisTable[i][j] = "";
    }
  }
  symbolsP = 0;
  for (int i = 0; i < BUFFER_SIZE; i++) {
    char buf[BUFFER_SIZE];
    sprintf(buf, "S%d", i);
    symbols[i] = strdup(buf);
  }
}

char* itoa(int n) {
  char s[BUFFER_SIZE];
  sprintf(s, "%d", n);
  return strdup(s);
}

char* ctoa(char c) {
  char s[BUFFER_SIZE];
  sprintf(s, "%c", c);
  return strdup(s);
}
