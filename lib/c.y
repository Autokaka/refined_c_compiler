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
void linkQuatenaryType();
void printSemanticAnalysis();
void prepareSemanticAnalysis();
char* semanticAnalysisTable[BUFFER_SIZE][5];
int semanticAnalysisP;
char* symbols[BUFFER_SIZE];
int symbolsP;

void printIdTable();
void buildIdTable();
char* ids[BUFFER_SIZE];
int idP;

char* itoa(int);
char* ctoa(char);
int atoi(const char*);

// extra debug configs
int showGrammarAnalysis = 0;
int showSemanticAnalysis = 0;
int showIdTable = 0;
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

  ids[idP++] = strdup($1);
  printIdTable($1);
  buildIdTable($1);
}

SubIdentifierTable: ',' Identifier SubIdentifierTable {
  char s[BUFFER_SIZE];
  sprintf(s, ",%s%s", $2, $3);
  $$ = strdup(s);

  char *str = "SubIdentifierTable => , Identifier SubIdentifierTable";
  buildGrammarAnalysisStack(str);
  printGrammarAnalysis(str);

  ids[idP++] = strdup($2);
  printIdTable($2);
  buildIdTable($2);
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

  assembleSemanticAnalysisTable($2, $1, $3, "");
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

  linkQuatenaryType();
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
  semanticAnalysisTable[semanticAnalysisP][0] = itoa(semanticAnalysisP);
  semanticAnalysisTable[semanticAnalysisP][1] = strdup(op);
  semanticAnalysisTable[semanticAnalysisP][2] = strdup(arg1);
  semanticAnalysisTable[semanticAnalysisP][3] = strdup(arg2);
  semanticAnalysisTable[semanticAnalysisP][4] = strdup(res);
  semanticAnalysisP++;
  if (semanticAnalysisP < 2) return;
  for (int i = 2; i < 4; i++) {
    char *last = semanticAnalysisTable[semanticAnalysisP - 1][i];
    char *current = semanticAnalysisTable[semanticAnalysisP - 2][4];
    if (strcmp(last, current) == 0 && strlen(current) != 0) {
      int continueFlag = 0;
      for (int j = 0; j < idP; j++) {
        if (strcmp(current, ids[j]) == 0) {
          continueFlag = 1;
        }
      }
      if (continueFlag) continue;
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

void linkQuatenaryType() {
  int i;
  for (i = 0; i < semanticAnalysisP; i++) {
    if (strlen(semanticAnalysisTable[i][4]) != 0) continue;
    // 向后移位, 空出i+1处
    for (int j = semanticAnalysisP; j > i + 1; j--) {
      semanticAnalysisTable[j][0] = itoa(atoi(semanticAnalysisTable[j - 1][0]) + 1);
      semanticAnalysisTable[j][1] = semanticAnalysisTable[j - 1][1];
      semanticAnalysisTable[j][2] = semanticAnalysisTable[j - 1][2];
      semanticAnalysisTable[j][3] = semanticAnalysisTable[j - 1][3];
      semanticAnalysisTable[j][4] = semanticAnalysisTable[j - 1][4];
    }
    semanticAnalysisP++;
    // i+1处添加condition = false的jump四元式
    semanticAnalysisTable[i + 1][0] = itoa(i + 1);
    semanticAnalysisTable[i + 1][1] = "j";
    semanticAnalysisTable[i + 1][2] = "-";
    semanticAnalysisTable[i + 1][3] = "-";
    semanticAnalysisTable[i + 1][4] = itoa(semanticAnalysisP);
    // 链接i处condition = true的jump四元式
    semanticAnalysisTable[i][4] = itoa(i + 2);
    break;
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
  idP = 0;
  for (int i = 0; i < BUFFER_SIZE; i++) {
    ids[i] = "";
  }
}

void printIdTable(const char *s) {
  if (!showIdTable) return;
  printf("found identifier: %s\n", s);
}

void buildIdTable(const char *s) {
  FILE* fp;
  fp = fopen("build/identifier_table", "a");
  fprintf(fp, "%s\n", s);
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

int atoi(const char *str) {
  if (NULL == str) {
    return 0;
  }
  int flag = 1;
  int s = 0;
  while (*str == ' ') {
    //去除开头空格
    str++;
  }
  if (*str == '+' || *str == '-') {
    if (*str == '-') {
      flag = -1;
    }
    str++;
  } else if (*str < '0' || *str > '9') {
    s = 2147483647;
    return s;
  }
  while (*str != '\0' && *str >= '0' && *str < '9') {
    //主要部分，减掉'0'是为了ASCII的码转为数字
    s = s * 10 + *str - '0';
    str++;
  }
  return s * flag;
}
