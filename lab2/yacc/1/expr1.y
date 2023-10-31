%{
#include<stdio.h>
#include<stdlib.h>
#ifndef YYSTYPE
#define YYSTYPE double
#endif
int yylex();
extern int yyparse();
FILE* yyin;
void yyerror(const char* s);
%}
//注意先后定义的优先级区别
//定义了算术运算符的优先级，越靠下优先级越高。`UMINUS`用于识别负数
%left '+' '-'
%left '*' '/'
%right UMINUS         

//定义语法规则
//说明如何从一个或者多个已知的符号组合生成新的符号
//一个语法规则的左边是一个非终结符,右边是由终结符和/费终结符组成的序列，右边和左边之间由冒号分隔，规则已符号结束
//文法右侧可以设定语法制导翻译的规则，识别到规则时自动执行
%%

lines   :       lines expr '\n' { printf("%f\n", $2); }
        |       lines '\n'
        |
        ;

expr    :       expr '+' expr   { $$=$1+$3; }
        |       expr '-' expr   { $$=$1-$3; }
        |       expr '*' expr   { $$=$1*$3; }
        |       expr '/' expr   { $$=$1/$3; }
        |       '('expr')'      { $$=$2;}
        |       '-' expr %prec UMINUS   {$$=-$2;}
        |       NUMBER
        ;
    
NUMBER  :       '0'         {$$=0.0;}
        |       '1'         {$$=1.0;}
        |       '2'         {$$=2.0;}
        |       '3'         {$$=3.0;}
        |       '4'         {$$=4.0;}
        |       '5'         {$$=5.0;}
        |       '6'         {$$=6.0;}
        |       '7'         {$$=7.0;}
        |       '8'         {$$=8.0;}
        |       '9'         {$$=9.0;}
        ;

%%

// programs section
//词法分析器
int yylex()
{
    return getchar();
}

int main(void)
{
    yyin=stdin;
    do{
        yyparse();
    }while(!feof(yyin));
    return 0;
}

//`yyerror`函数用于处理语法错误，当`yacc`生成的`yyparse`函数遇到错误时，它会调用这个函数。这里的实现简单地打印错误消息并退出。
void yyerror(const char* s){
    fprintf(stderr,"Parse error: %s\n",s);
    exit(1);
}