%{
#include <stdio.h>
#include <math.h>
#include <string.h>
int yylex(void);
int yyerror(const char *s);
int success = 1;

// extra debug config
int showStackTrace = 1;
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

%%
Program: MainDeclaration '(' ')' '{' SubProgram '}' {
  if (showStackTrace) {
    printf("↑\033[32mProgram: MainDeclaration '{' SubProgram '}'\033[0m\n");
  }
}

SubProgram: VarDeclarationPart ';' SentencePart {
  if (showStackTrace) {
    printf("↑\033[32mSubProgram: VarDeclarationPart ';' SentencePart\033[0m\n");
  }
}

VarDeclarationPart: VarDeclaration IdentifierTable {
  if (showStackTrace) {
    printf("↑\033[32mVarDeclarationPart: VarDeclaration IdentifierTable\033[0m\n");
  }
}

IdentifierTable: Identifier SubIdentifierTable {
  if (showStackTrace) {
    printf("↑\033[32mIdentifierTable: Identifier SubIdentifierTable\033[0m\n");
  }
}

SubIdentifierTable: ',' Identifier SubIdentifierTable {
  if (showStackTrace) {
    printf("↑\033[32mSubIdentifierTable: ',' Identifier SubIdentifierTable\033[0m\n");
  }
} | {
  if (showStackTrace) {
    printf("↑\033[32mSubIdentifierTable: ε\033[0m\n");
  }
}

Identifier: Letter {
  if (showStackTrace) {
    printf("↑\033[32mIdentifier: Letter\033[0m\n");
  }
} | Identifier Letter {
  if (showStackTrace) {
    printf("↑\033[32mIdentifier: Identifier Letter\033[0m\n");
  }
} | Identifier Number {
  if (showStackTrace) {
    printf("↑\033[32mIdentifier: Identifier Number\033[0m\n");
  }
}

SentencePart: Sentence SubSentencePart {
  if (showStackTrace) {
    printf("↑\033[32mSentencePart: Sentence SubSentencePart\033[0m\n");
  }
}

SubSentencePart: ';' Sentence SubSentencePart {
  if (showStackTrace) {
    printf("↑\033[32mSubSentencePart: ';' Sentence SubSentencePart\033[0m\n");
  }
} | {
  if (showStackTrace) {
    printf("↑\033[32mSubSentencePart: ε\033[0m\n");
  }
}

Sentence: AssignSentence {
  if (showStackTrace) {
    printf("↑\033[32mSentence: AssignSentence\033[0m\n");
  }
} | ConditionSentence {
  if (showStackTrace) {
    printf("↑\033[32mSentence: ConditionSentence\033[0m\n");
  }
} | LoopSentence {
  if (showStackTrace) {
    printf("↑\033[32mSentence: LoopSentence\033[0m\n");
  }
}

AssignSentence: Identifier '=' Expression {
  if (showStackTrace) {
    printf("↑\033[32mAssignSentence: Identifier '=' Expression\033[0m\n");
  }
}

Condition: Expression RelationOperator Expression {
  if (showStackTrace) {
    printf("↑\033[32mCondition: Expression RelationOperator Expression\033[0m\n");
  }
}

Expression: Term SubExpression {
  if (showStackTrace) {
    printf("↑\033[32mExpression: Term SubExpression\033[0m\n");
  }
}

SubExpression: AddOperator Term SubExpression {
  if (showStackTrace) {
    printf("↑\033[32mSubSxpression: AddOperator Term SubSxpression\033[0m\n");
  }
} | {
  if (showStackTrace) {
    printf("↑\033[32mSubSxpression: ε\033[0m\n");
  }
}

Term: Factor SubTerm {
  if (showStackTrace) {
    printf("↑\033[32mTerm: Factor SubTerm\033[0m\n");
  }
}

SubTerm: MultiplyOperator Factor SubTerm {
  if (showStackTrace) {
    printf("↑\033[32mSubTerm: MultiplyOperator Factor Term\033[0m\n");
  }
} | {
  if (showStackTrace) {
    printf("↑\033[32mSubTerm: ε\033[0m\n");
  }
}

Factor: Identifier {
  if (showStackTrace) {
    printf("↑\033[32mFactor: Identifier\033[0m\n");
  }
} | ConstValue {
  if (showStackTrace) {
    printf("↑\033[32mFactor: ConstValue\033[0m\n");
  }
} | '(' Expression ')' {
  if (showStackTrace) {
    printf("↑\033[32mFactor: '(' Expression ')'\033[0m\n");
  }
}

ConstValue: UnsignedInteger {
  if (showStackTrace) {
    printf("↑\033[32mConstValue: UnsignedInteger\033[0m\n");
  }
}

UnsignedInteger: NumberSequence {
  if (showStackTrace) {
    printf("↑\033[32mUnsignedInteger: NumberSequence\033[0m\n");
  }
}

NumberSequence: NumberSequence Number {
  if (showStackTrace) {
    printf("↑\033[32mNumberSequence: NumberSequence Number\033[0m\n");
  }
} | Number {
  if (showStackTrace) {
    printf("↑\033[32mNumberSequence: Number\033[0m\n");
  }
}

ComplexSentence: '{' SentencePart '}' {
  if (showStackTrace) {
    printf("↑\033[32mComplexSentence: '{' SentencePart '}'\033[0m\n");
  }
}

Sentence1: Sentence {
  if (showStackTrace) {
    printf("↑\033[32mSentence1: Sentence\033[0m\n");
  }
} | ComplexSentence {
  if (showStackTrace) {
    printf("↑\033[32mSentence1: ComplexSentence\033[0m\n");
  }
}

ConditionSentence: IfStatement '(' Condition ')' Sentence1 ElseStatement Sentence1 {
  if (showStackTrace) {
    printf("↑\033[32mConditionSentence: IfStatement '(' Condition ')' Sentence1 ElseStatement Sentence1\033[0m\n");
  }
}

LoopSentence: WhileStatement '(' Condition ')' DoStatement Sentence1 {
  if (showStackTrace) {
    printf("↑\033[32mLoopSentence: WhileStatement '(' Condition ')' Sentence1\033[0m\n");
  }
}

%%

int main(void) {
  return yyparse();
  if (success) {
    printf("0 warnings, 0 errors. Language accepted!\n");
  }
  return 0;
}

int yyerror(const char *s) {
  extern int yylineno;
	extern char *yytext;
  fprintf(stderr, "\033[31mError: '%s' at line: %d: %s\033[0m\n", yytext, yylineno, s);
	success = 0;
	return 0;
}
