%{
#include <stdio.h>
#include <math.h>
extern int yylineno;
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

IdentifierTable: IdentifierTable ',' Identifier {
  if (showStackTrace) {
    printf("↑\033[32mIdentifierTable: IdentifierTable ',' Identifier\033[0m\n");
  }
} | Identifier {
  if (showStackTrace) {
    printf("↑\033[32mIdentifierTable: Identifier\033[0m\n");
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

SentencePart: SentencePart ';' Sentence {
  if (showStackTrace) {
    printf("↑\033[32mSentencePart: SentencePart ';' Sentence\033[0m\n");
  }
} | Sentence {
  if (showStackTrace) {
    printf("↑\033[32mSentencePart: Sentence\033[0m\n");
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

Expression: Term {
  if (showStackTrace) {
    printf("↑\033[32mExpression: Term\033[0m\n");
  }
} | Expression AddOperator Term {
  if (showStackTrace) {
    printf("↑\033[32mExpression: Expression AddOperator Term\033[0m\n");
  }
}

Term: Factor {
  if (showStackTrace) {
    printf("↑\033[32mTerm: Factor\033[0m\n");
  }
} | Term MultiplyOperator Factor {
  if (showStackTrace) {
    printf("↑\033[32mTerm: Term MultiplyOperator Factor\033[0m\n");
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

LoopSentence: WhileStatement '(' Condition ')' Sentence1 {
  if (showStackTrace) {
    printf("↑\033[32mLoopSentence: WhileStatement '(' Condition ')' Sentence1\033[0m\n");
  }
} | DoStatement Sentence1 WhileStatement '(' Condition ')' ';' {
  if (showStackTrace) {
    printf("↑\033[32mLoopSentence: DoStatement Sentence1 WhileStatement '(' Condition ')' ';'\033[0m\n");
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

int yyerror(const char *msg) {
	fprintf(stderr, "Error: at line: %d: %s\n", yylineno, msg);
	success = 0;
	return 0;
}
