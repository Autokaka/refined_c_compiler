%{
#include <stdio.h>
void yyerror(char *s);
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
%token <str_type>   RelationOperator  // <|>|!=|>=|<=|==
%token <str_type>   IfStatement         // if
%token <str_type>   ElseStatement       // else
%token <str_type>   WhileStatement      // while
%token <str_type>   DoStatement         // do
%token <char_type>  Letter              // a|b|c...
%token <char_type>  AddOperator         // +|-
%token <char_type>  MultiplyOperator    // *|/
%token <int_type>   Number              // 0|1|2|3|4...

/* 非终结符 */
%start MainProgram
%type <str_type> MainProgram
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
MainProgram: MainDeclaration '{' SubProgram '}' {
  printf("main program\n");
}

SubProgram: VarDeclarationPart ';' SentencePart {
  printf("sub program\n");
}

VarDeclarationPart: VarDeclaration IdentifierTable {
  printf("var declaration part\n");
}

IdentifierTable: IdentifierTable ',' Identifier | Identifier {
  printf("identifier table\n");
}

Identifier: Letter | Identifier Letter | Identifier Number {
  printf("Identifier\n");
}

SentencePart: SentencePart ';' Sentence | Sentence {
  printf("sentence part\n");
}

Sentence: AssignSentence | ConditionSentence | LoopSentence {
  printf("sentence\n");
}

AssignSentence: Identifier '=' Expression {
  printf("assign sentence\n");
}

Condition: Expression RelationOperator Expression {
  printf("condition\n");
}

Expression: Term | Expression AddOperator Term {
  printf("expression\n");
}

Term: Factor | Term MultiplyOperator Factor {
  printf("term\n");
}

Factor: Identifier | ConstValue | '(' Expression ')' {
  printf("factor\n");
}

ConstValue: UnsignedInteger {
  printf("const value\n");
}

UnsignedInteger: NumberSequence {
  printf("unsigned integer\n");
}

NumberSequence: NumberSequence Number | Number {
  printf("number sequence\n");
}

ComplexSentence: '{' SentencePart '}' {
  printf("complex sentence\n");
}

Sentence1: Sentence | ComplexSentence {
  printf("sentence 1\n");
}

ConditionSentence: IfStatement '(' Condition ')' Sentence1 ElseStatement Sentence1 {
  printf("condition sentence\n");
}

LoopSentence: WhileStatement '(' Condition ')' DoStatement Sentence1 {
  printf("loop statement\n");
}

%%

int main(void) {
  return yyparse();
}

void yyerror(char *s) {
  printf("yyerror: %s\n", s);
}
