%{
/*********************************************
实现中缀表达式到后缀表达式的转换
**********************************************/
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<ctype.h>
#ifndef YYSTYPE
#define YYSTYPE char*
//类型改称char*，因为要返回的是后缀表达式，是字符串
#endif
char idStr[50];
char numStr[50];
int yylex();
extern int yyparse();
FILE* yyin;
void yyerror(const char* s);
%}

%token ADD MINUS
%token MUL DIV
%token NUMBER
%token L_PAR R_PAR
%token ID
//添加标识符，由数字、字母、下划线组成，第一个字符不可以是数字

//声明运算符的左右结合性及优先级
%left ADD MINUS
%left MUL DIV
%right UMINUS         
%right L_PAR
%left R_PAR


//规则段：规则段部分为进行语法分析的部分，包括上下文无关文法及翻译模式，大括号内的部分即为语义动作。
//$$ 代表产生式左部的属性值，$n 为产生式右部第 n 个 token 的属性值，注意运算符等终结符
//也计算其中，即，不止非终结符有属性值，终结符也有属性值。
%%
//使用分号替换lines产生式中的\n,测试程序时简单表达式以分号结束而不是回车结束
//这样实现词法分析忽略回车
lines   :       lines expr ';' { printf("%s\n", $2); }
        |       lines ';'
        |
        ;
//TODO:完善表达式的规则./
expr    :       expr ADD expr   { $$=(char*)malloc(50*sizeof(char)); strcpy($$,$1); strcat($$,$3); strcat($$,"+ "); }
                //a+b变为ab+
        |       expr MINUS expr   { $$=(char*)malloc(50*sizeof(char)); strcpy($$,$1); strcat($$,$3); strcat($$,"- "); }
        |       expr MUL expr   { $$=(char*)malloc(50*sizeof(char)); strcpy($$,$1); strcat($$,$3); strcat($$,"* "); }
        |       expr DIV expr   { $$=(char*)malloc(50*sizeof(char)); strcpy($$,$1); strcat($$,$3); strcat($$,"/ "); } 
        |       L_PAR expr R_PAR { $$=(char *)malloc(50*sizeof(char)); strcpy($$,$2); }
        |       MINUS expr %prec UMINUS   {$$=(char *)malloc(50*sizeof(char)); strcpy($$,$2); strcat($$,"- "); }
        //将NUMBER视为终结符，添加语义动作，将yylval的值赋给NUMBER的属性值
        |       NUMBER  {$$=(char *)malloc(50*sizeof(char)); strcpy($$,$1); strcat($$," "); }
        |       ID  {$$=(char *)malloc(50*sizeof(char)); strcpy($$,$1); strcat($$," ");}
        ;
%%

// programs section

int yylex()
{
    int t;
    while(1){
        t=getchar();
        if(t==' '||t=='\t'||t=='\n'){
            //do noting 忽略空格，制表符,换行
        }
        //先判断数字，与上一问是一样的，改成了字符串
        else if(isdigit(t)){
            int ti=0;
            while(isdigit(t))
            {
                numStr[ti] = t;
                ti++;
                t=getchar();
            }
            numStr[ti]='\0';//数组最后一个元素加上"\0"，表示字符串结束
            yylval=numStr;
            ungetc(t,stdin);
            return NUMBER;
        }else if((t>='a'&&t<='z')||(t>='A'&&t<='Z')||(t=='_')){
            int ti=0;
            while((t>='a'&&t<='z')||(t>='A'&&t<='Z')||(t=='_')||(isdigit(t)))
            {
                idStr[ti]=t;
                ti++;
                t=getchar();
            }
            idStr[ti]='\0';//数组最后一个元素加上"\0"，表示字符串结束
            yylval=idStr;
            ungetc(t,stdin);
            return ID; 
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
        }else{
            return t;
        }
    }
}

int main(void)
{
    yyin=stdin;
    do{
        yyparse();
    }while(!feof(yyin));
    return 0;
}
void yyerror(const char* s){
    fprintf(stderr,"Parse error: %s\n",s);
    exit(1);
}