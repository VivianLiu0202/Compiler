%{
/*********************************************
将所有的词法分析功能均放在 yylex 函数内实现，为 +、-、*、\、(、 ) 每个运算符及整数分别定义一个单词类别，在 yylex 内实现代码，能
识别这些单词，并将单词类别返回给词法分析程序。
实现功能更强的词法分析程序，可识别并忽略空格、制表符、回车等
空白符，能识别多位十进制整数。
YACC file
**********************************************/
#include<stdio.h>
#include<stdlib.h>
#include<ctype.h>
#ifndef YYSTYPE
#define YYSTYPE double
//YYSTYPE用于确定$$变量类型，我们要翻译的结果是表达式值,所以类型是double
//PS:yylval是YACC一个重要接口。
//全局变量，用于在词法分析器和语法分析器之间传递语义值。
#endif
int yylex();
extern int yyparse();
FILE* yyin;
void yyerror(const char* s);
%}

//TODO:给每个符号定义一个单词类别
%token ADD MINUS
%token MUL DIV
%token NUMBER
%token L_PAR R_PAR

//声明运算符的左右结合性及优先级
%left ADD MINUS
%left MUL DIV
%right UMINUS         
%right L_PAR
%left R_PAR



//规则段：规则段部分为进行语法分析的部分，包括上下文无关文法及翻译模式，大括号内的部分即为语义动作。
//$$ 代表产生式左部的属性值，$n 为产生式右部第 n 个 token 的属性值
//注意运算符等终结符也计算其中，即，不止非终结符有属性值，终结符也有属性值。
%%
//lines用于处理多行输入，每行都是一个表达式。
//使用分号替换lines产生式中的\n,测试程序时简单表达式以分号结束而不是回车结束
//这样实现词法分析忽略回车
lines   :       lines expr ';' { printf("%f\n", $2); }
        |       lines ';'
        |
        ;
//TODO:完善表达式的规则./
expr    :       expr ADD expr   { $$=$1+$3; }
        |       expr MINUS expr   { $$=$1-$3; }
        |       expr MUL expr   { $$=$1*$3; }
        |       expr DIV expr   { $$=$1/$3; } 
        |       L_PAR expr R_PAR { $$=$2; }
        |       MINUS expr %prec UMINUS   {$$=-$2;}
        //将NUMBER视为终结符，添加语义动作，将yylval的值赋给NUMBER的属性值
        |       NUMBER  {$$=$1;}
        ;
//当词法分析器识别到一个数值时，它会返回一个代表该数值的token，通常命名为NUMBER
//同时，该数值会被存储在yylval中，这是YACC或Bison用来传递词法值的变量。
//NUMBER=yylval是隐式赋值给终结符的属性值$1，然后expr=NUMBER,也就是$$=$1，
//语义动作中不用再显式执行$$=yylval，如果什么都不写，其实yacc也会自动执行$$=$1
/*
NUMBER : '0' {$$=0.0;}
       | '1' {$$=1.0;}  
       | '2' {$$=2.0;}
       | '3' {$$=3.0;}
       | '4' {$$=4.0;}
       | '5' {$$=5.0;}
       | '6' {$$=6.0;}
       | '7' {$$=7.0;}
       | '8' {$$=8.0;}
       | '9' {$$=9.0;}    
*/
%%

// programs section

int yylex()
{
    int t;
    double numValue = 0; // 用于存储多位数字的值
    while(1){
        t=getchar();
        if(t==' '||t=='\t'||t=='\n'){
            //do noting 忽略空格，制表符,换行
        }
        else if(isdigit(t)){
            //TODO:解析多位数字返回数字类型 
            ungetc(t,stdin); //将刚刚读取的数字字符t推回到输入流stdin，读取整个数字时，这个字符不会被遗漏
            scanf("%lf",&numValue);// 读取多位数字
            yylval = numValue; // 将数字值存储在yylval中
            return NUMBER;
        }else if(t=='+'){
            return ADD;
        }else if(t=='-'){
            return MINUS;
        }//TODO:识别其他符号
        else if(t=='*'){
            return MUL;
        }else if(t=='/'){
            return DIV;
        }else if(t=='('){
            return L_PAR;
        }else if(t==')'){
            return R_PAR;
        }
        else{
            return t;
        }
    }
}

// `main`函数将`yyin`设置为标准输入`stdin`，然后不断调用`yyparse`直到达到文件尾。这意味着此程序从标准输入读取数据，并为每一行计算结果。
int main(void)
{
    yyin=stdin;
    do{
        yyparse();
    }while(!feof(yyin));
    return 0;
}
//yyerror函数用于处理语法错误，当yacc生成的yyparse函数遇到错误时，它会调用这个函数。这里的实现简单地打印错误消息并退出。
void yyerror(const char* s){
    fprintf(stderr,"Parse error: %s\n",s);
    exit(1);
}