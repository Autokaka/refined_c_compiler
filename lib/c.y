%{
#include <stdio.h>
#include <math.h>
int yylex(void);
int yyerror(const char *s);

void buildGrammarAnalysisStack(const char *);
void printDerivation(const char *);

// extra debug configs
int showStackTrace = 1;
%}

/* 类型 */
%union {
  int int_type; 
  char char_type;
  char *str_type;
}

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
  char *str = "Program => MainDeclaration { SubProgram }";
  buildGrammarAnalysisStack(str);
  printDerivation(str);
}

SubProgram: VarDeclarationPart ';' SentencePart {
  char *str = "SubProgram => VarDeclarationPart ; SentencePart";
  buildGrammarAnalysisStack(str);
  printDerivation(str);
} | {
  char *str = "SubProgram => ε";
  buildGrammarAnalysisStack(str);
  printDerivation(str);
}

VarDeclarationPart: VarDeclaration IdentifierTable {
  char *str = "VarDeclarationPart => VarDeclaration IdentifierTable";
  buildGrammarAnalysisStack(str);
  printDerivation(str);
}

IdentifierTable: Identifier SubIdentifierTable {
  char *str = "IdentifierTable => Identifier SubIdentifierTable";
  buildGrammarAnalysisStack(str);
  printDerivation(str);
}

SubIdentifierTable: ',' Identifier SubIdentifierTable {
  char *str = "SubIdentifierTable => , Identifier SubIdentifierTable";
  buildGrammarAnalysisStack(str);
  printDerivation(str);
} | {
  char *str = "SubIdentifierTable => ε";
  buildGrammarAnalysisStack(str);
  printDerivation(str);
}

Identifier: Letter {
  char *str = "Identifier => Letter";
  buildGrammarAnalysisStack(str);
  printDerivation(str);
} | Identifier Letter {
  char *str = "Identifier => Identifier Letter";
  buildGrammarAnalysisStack(str);
  printDerivation(str);
} | Identifier Number {
  char *str = "Identifier => Identifier Number";
  buildGrammarAnalysisStack(str);
  printDerivation(str);
}

SentencePart: Sentence SubSentencePart {
  char *str = "SentencePart => Sentence SubSentencePart";
  buildGrammarAnalysisStack(str);
  printDerivation(str);
}

SubSentencePart: ';' Sentence SubSentencePart {
  char *str = "SubSentencePart => ; Sentence SubSentencePart";
  buildGrammarAnalysisStack(str);
  printDerivation(str);
} | {
  char *str = "SubSentencePart => ε";
  buildGrammarAnalysisStack(str);
  printDerivation(str);
}

Sentence: AssignSentence {
  char *str = "Sentence => AssignSentence";
  buildGrammarAnalysisStack(str);
  printDerivation(str);
} | ConditionSentence {
  char *str = "Sentence => ConditionSentence";
  buildGrammarAnalysisStack(str);
  printDerivation(str);
} | LoopSentence {
  char *str = "Sentence => LoopSentence";
  buildGrammarAnalysisStack(str);
  printDerivation(str);
} | {
  char *str = "Sentence => ε";
  buildGrammarAnalysisStack(str);
  printDerivation(str);
}

AssignSentence: Identifier '=' Expression {
  char *str = "AssignSentence => Identifier = Expression";
  buildGrammarAnalysisStack(str);
  printDerivation(str);
}

Condition: Expression RelationOperator Expression {
  char *str = "Condition => Expression RelationOperator Expression";
  buildGrammarAnalysisStack(str);
  printDerivation(str);
}

Expression: Term SubExpression {
  char *str = "Expression => Term SubExpression";
  buildGrammarAnalysisStack(str);
  printDerivation(str);
}

SubExpression: AddOperator Term SubExpression {
  char *str = "SubSxpression => AddOperator Term SubSxpression";
  buildGrammarAnalysisStack(str);
  printDerivation(str);
} | {
  char *str = "SubSxpression => ε";
  buildGrammarAnalysisStack(str);
  printDerivation(str);
}

Term: Factor SubTerm {
  char *str = "Term => Factor SubTerm";
  buildGrammarAnalysisStack(str);
  printDerivation(str);
}

SubTerm: MultiplyOperator Factor SubTerm {
  char *str = "SubTerm => MultiplyOperator Factor Term";
  buildGrammarAnalysisStack(str);
  printDerivation(str);
} | {
  char *str = "SubTerm => ε";
  buildGrammarAnalysisStack(str);
  printDerivation(str);
}

Factor: Identifier {
  char *str = "Factor => Identifier";
  buildGrammarAnalysisStack(str);
  printDerivation(str);
} | ConstValue {
  char *str = "Factor => ConstValue";
  buildGrammarAnalysisStack(str);
  printDerivation(str);
} | '(' Expression ')' {
  char *str = "Factor => ( Expression )";
  buildGrammarAnalysisStack(str);
  printDerivation(str);
}

ConstValue: UnsignedInteger {
  char *str = "ConstValue => UnsignedInteger";
  buildGrammarAnalysisStack(str);
  printDerivation(str);
}

UnsignedInteger: NumberSequence {
  char *str = "UnsignedInteger => NumberSequence";
  buildGrammarAnalysisStack(str);
  printDerivation(str);
}

NumberSequence: Number SubNumberSequence {
  char *str = "NumberSequence => Number SubNumberSequence";
  buildGrammarAnalysisStack(str);
  printDerivation(str);
}

SubNumberSequence: Number SubNumberSequence {
  char *str = "SubNumberSequence => Number SubNumberSequence";
  buildGrammarAnalysisStack(str);
  printDerivation(str);
} | {
  char *str = "SubNumberSequence => ε";
  buildGrammarAnalysisStack(str);
  printDerivation(str);
}

ComplexSentence: '{' SentencePart '}' {
  char *str = "ComplexSentence => { SentencePart }";
  buildGrammarAnalysisStack(str);
  printDerivation(str);
}

Sentence1: Sentence {
  char *str = "Sentence1 => Sentence";
  buildGrammarAnalysisStack(str);
  printDerivation(str);
} | ComplexSentence {
  char *str = "Sentence1 => ComplexSentence";
  buildGrammarAnalysisStack(str);
  printDerivation(str);
}

ConditionSentence: IfStatement '(' Condition ')' Sentence1 ElseStatement Sentence1 {
  char *str = "ConditionSentence => IfStatement ( Condition ) Sentence1 ElseStatement Sentence1";
  buildGrammarAnalysisStack(str);
  printDerivation(str);
}

LoopSentence: WhileStatement '(' Condition ')' DoStatement Sentence1 {
  char *str = "LoopSentence => WhileStatement ( Condition ) Sentence1";
  buildGrammarAnalysisStack(str);
  printDerivation(str);
}

%%

int main(void) {
  int hasError = yyparse();
  if (hasError) {
    printf("\033[31m///////////////////////////////////////////////////////\033[0m\n");
    printf("\033[31m///////  parse failed: terminated with errors.  ///////\033[0m\n");
    printf("\033[31m///////////////////////////////////////////////////////\033[0m\n");
  } else {
    printf("\033[32m//////////////////////////////////////////////////////////\033[0m\n");
    printf("\033[32m///////  0 warnings, 0 errors. Language accepted!  ///////\033[0m\n");
    printf("\033[32m//////////////////////////////////////////////////////////\033[0m\n");
    return 0;
  }
}

int yyerror(const char *s) {
  extern int yylineno;
	extern char *yytext;
  fprintf(stderr, "\033[31mError: '%s' at line: %d: %s\033[0m\n", yytext, yylineno, s);
	return 1;
}

void buildGrammarAnalysisStack(const char *str) {
  FILE* fp;
  fp = fopen("build/grammar_analysis_stack", "a");
  fprintf(fp, "%s\n", str);
  fclose(fp);
}

void printDerivation(const char *str) {
  if (!showStackTrace) return;
  printf("%s\n", str);
}
