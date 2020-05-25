%{
#include <stdio.h>
#include <math.h>
extern int yylineno;
int yylex(void);
int yyerror(const char *s);
int success = 1;
%}

/* 类型 */
%union {
  int int_type; 
  char char_type;
  char* str_type;
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
%type <str_type> Sentence
%type <str_type> Sentence1
%type <str_type> ComplexSentence
%type <str_type> IdentifierTable
%type <str_type> Identifier
%type <str_type> AssignSentence
%type <str_type> ConditionSentence
%type <str_type> LoopSentence
%type <str_type> Expression
%type <str_type> Condition
%type <str_type> Term
%type <str_type> Factor
%type <str_type> ConstValue
%type <str_type> UnsignedInteger
%type <str_type> NumberSequence

%%
Program: MainDeclaration '{' SubProgram '}' {
  printf("MainProgram: %s { %s }\n", $1, $3);
}

SubProgram: VarDeclarationPart ';' SentencePart {
  printf("SubProgram: %s ; %s\n", $1, $3);
}

VarDeclarationPart: VarDeclaration IdentifierTable {
  printf("VarDeclarationPart: %s %s\n", $1, $2);
}

IdentifierTable: IdentifierTable ',' Identifier {
  printf("IdentifierTable: %s , %s\n", $1, $3);
} | Identifier {
  printf("IdentifierTable: %s\n", $1);
}

Identifier: Letter {
  printf("Identifier: %c\n", $1);
} | Identifier Letter {
  printf("Identifier: %s %c\n", $1, $2);
} | Identifier Number {
  printf("Identifier: %s %d\n", $1, $2);
}

SentencePart: SentencePart ';' Sentence {
  printf("SentencePart: %s ; %s\n", $1, $3);
} | Sentence {
  printf("SentencePart: %s\n", $1);
}

Sentence: AssignSentence {
  printf("Sentence: %s\n", $1);
} | ConditionSentence {
  printf("Sentence: %s\n", $1);
} | LoopSentence {
  printf("Sentence: %s\n", $1);
}

AssignSentence: Identifier '=' Expression {
  printf("AssignSentence: %s = %s\n", $1, $3);
}

Condition: Expression RelationOperator Expression {
  printf("Condition: %s %s %s\n", $1, $2, $3);
}

Expression: Term {
  printf("Expression: %s\n", $1);
} | Expression AddOperator Term {
  printf("Expression: %s %c %s\n", $1, $2, $3);
}

Term: Factor {
  printf("Term: %s\n", $1);
} | Term MultiplyOperator Factor {
  printf("Term: %s %c %s\n", $1, $2, $3);
}

Factor: Identifier {
  printf("Factor: %s\n", $1);
} | ConstValue {
  printf("Factor: %s\n", $1);
} | '(' Expression ')' {
  printf("Factor: ( %s )\n", $2);
}

ConstValue: UnsignedInteger {
  printf("ConstValue: %s\n", $1);
}

UnsignedInteger: NumberSequence {
  printf("UnsignedInteger: %s\n", $1);
}

NumberSequence: NumberSequence Number {
  printf("NumberSequence: %s %d\n", $1, $2);
} | Number {
  printf("NumberSequence: %d\n", $1);
}

ComplexSentence: '{' SentencePart '}' {
  printf("ComplexSentence: { %s }\n", $2);
}

Sentence1: Sentence {
  printf("Sentence1: %s\n", $1);
} | ComplexSentence {
  printf("Sentence1: %s\n", $1);
}

ConditionSentence: IfStatement '(' Condition ')' Sentence1 ElseStatement Sentence1 {
  printf("ConditionSentence: %s ( %s ) %s %s %s\n", $1, $3, $5, $6, $7);
}

LoopSentence: WhileStatement '(' Condition ')' DoStatement Sentence1 {
  printf("LoopSentence: %s ( %s ) %s %s\n", $1, $3, $5, $6);
}

%%

int main(void) {
  return yyparse();
  if (success) {
    printf("0 warnings, 0 errors. Language accepted!\n");
  }
  return 0;
}

int yyerror(const char *msg) {
	printf("Error: at line: %d: %s\n", yylineno, msg);
	success = 0;
	return 0;
}
