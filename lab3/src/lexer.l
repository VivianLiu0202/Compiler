%option noyywrap
%option nounput
%option noinput
%top{
    #include <stdarg.h>
    #include <stdio.h>
    #include <string.h>
    #include "common.h"
}
%{
    //int column_start = 0;
    int yycolumn = 1; //初始化列号
    extern dump_type_t dump_type;
    //dump_tokens 函数现在接收行号和列号作为参数，并在输出中包含它们
    //该函数接受可变擦书列表（由...表示），允许以自定义格式输出信息。
    inline void dump_tokens(int lineno, int column, const char* format, ...) {
        va_list args;
        va_start(args, format);
        if (dump_type == TOKENS) {
            char buffer[256]; // 创建一个缓冲区来存储格式化的输出
            vsnprintf(buffer, sizeof(buffer), format, args); // 将格式化的输出存储在缓冲区中
            // 输出格式化的文本，行号和列号，并确保每个字段都有固定的宽度
            fprintf(yyout, "%-20s\t%-10d\t%-10d", buffer,lineno, column);
        }    
        va_end(args);//清理为args分配的内存
    }

    /* Your code here, if desired (lab3). */
    typedef struct SymbolTable{
        char* name; // 标识符的名称
        int type; // 标识符的类型，0是int 1是void
        int value; // 标识符的值
        int scope;// 标识符的作用域
        struct SymbolTable* next; //指向同一作用域内的下一个符号表，形成链表
    }SymbolTable;

    #define MAX_SYMBOL_TABLE_SIZE 100
    //这个栈保存的是每一层作用域的符号表（链表）的头指针，符号表项通过next指针串联起来，形成链表
    //不同作用域的符号表则是数组的不同元素，这里采用
    SymbolTable* symbolTableStack[MAX_SYMBOL_TABLE_SIZE];
    int stackTop=0;//跟踪栈顶的位置，初始为0

    void addSymbol(char* name, int type, int value,int scope);
    SymbolTable* checkSymbol(char* name);
    void enterScope();
    void reduceScope();
%}

/* definitions section */
/*  Your code here (lab3). */
DECIMIAL ([1-9][0-9]*|0)
OCTAL (0[1-7][0-7]*|0)
HEXAL (0(x|X)[1-9a-fA-F][0-9a-fA-F]*|0)
/* FLOAT ((([0-9]*[.][0-9]*([eE][+-]?[0-9]+)?)|([0-9]+[eE][+-]?[0-9]+))[fLlL]?) */
/*FLOAT ([0-9]*"."[0-9]+([eE][-+]?[0-9]+)?|[0-9]+[eE][-+]?[0-9]+)*/
FLOAT (([0-9]*"."[0-9]+([eE][-+]?[0-9]+)?)|0[xX][0-9a-fA-F]+(\.[0-9a-fA-F]+)?([pP][-+]?[0-9]+)?)
ID [[:alpha:]_][[:alpha:][:digit:]_]*

/*匹配行尾，回车or换行*/
EOL (\r\n|\n|\r) 
/*匹配制表符和空格*/
WHITE [\t ]

COMMENTBEGIN  "/*"  
COMMENTEOL  (\r\n|\n|\r)
/*.匹配除了换行符之外的所有字符*/
COMMENTELEMENT  .
COMMENTEND   "*/"
LINECOMMENT (\/\/[^\n]*)
%x BLOCKCOMMENT
/*这是词法分析器的一个状态（开始条件），通常用于处理多行注释。在此状态下，lexer会匹配特定的tokens，如COMMENTELEMENT, COMMENTEOL, COMMENTEND。*/


%%
    /* rules section */
"int" {
    //dump_tokens("INT\t%s\n", yytext);
    //int column = yycolumn - column_start;
    int start_column = yycolumn; // 保存token开始的列号
    yycolumn += yyleng; // 更新列号
    //dump_tokens(yylineno, start_column, "INT\t%s", yytext);//增加行号和列号
    dump_tokens(yylineno, start_column, "%-10s\t%s", "INT", yytext);
    fprintf(yyout, "\n"); // 添加换行符
}

"float" {
    int start_column = yycolumn; // 保存token开始的列号
    yycolumn += yyleng; // 更新列号
    //dump_tokens(yylineno, start_column, "INT\t%s", yytext);//增加行号和列号
    dump_tokens(yylineno, start_column, "%-10s\t%s", "FLOAT", yytext);
    fprintf(yyout, "\n"); // 添加换行符 
}

"void" {
    //int column = yycolumn - column_start;
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s", "VOID", yytext);
    fprintf(yyout, "\n"); // 添加换行符
    
}

"if" {
    
    //int column = yycolumn - column_start;
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s", "IF", yytext); 
    fprintf(yyout, "\n"); // 添加换行符
}

"else" {
    //int column = yycolumn - column_start;
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s", "ELSE", yytext);
    fprintf(yyout, "\n"); // 添加换行符
}

"return" {
    //int column = yycolumn - column_start;
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s", "RETURN", yytext);
    fprintf(yyout, "\n"); // 添加换行符
}

"char" {
    //int column = yycolumn - column_start;
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s", "CHAR", yytext);
    fprintf(yyout, "\n"); // 添加换行符
}

"short" {
    //int column = yycolumn - column_start;
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s", "SHORT", yytext);
    fprintf(yyout, "\n"); // 添加换行符
}

"long" {
    //int column = yycolumn - column_start;
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s", "LONG", yytext);
    fprintf(yyout, "\n"); // 添加换行符
}

"const" {
    //int column = yycolumn - column_start;
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s", "CONST", yytext);
    fprintf(yyout, "\n"); // 添加换行符
}

"for" {
    //int column = yycolumn - column_start;
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s", "FOR", yytext);
    fprintf(yyout, "\n"); // 添加换行符
}

"while" {
    //int column = yycolumn - column_start;
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s", "WHILE", yytext);
    fprintf(yyout, "\n"); // 添加换行符
}

"do" {
    //int column = yycolumn - column_start;
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s", "DO", yytext);
    fprintf(yyout, "\n"); // 添加换行符
}

"break" {
    //int column = yycolumn - column_start;
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s", "BREAK", yytext);
    fprintf(yyout, "\n"); // 添加换行符
}

"continue" {
    //int column = yycolumn - column_start;
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s", "CONTINUE", yytext);
    fprintf(yyout, "\n"); // 添加换行符
}

"switch" {
    //int column = yycolumn - column_start;
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s", "SWITCH", yytext);
    fprintf(yyout, "\n"); // 添加换行符
}

"case" {
    //int column = yycolumn - column_start;
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s", "CASE", yytext);
    fprintf(yyout, "\n"); // 添加换行符
}

"default" {
    //int column = yycolumn - column_start;
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s", "DEFAULT", yytext);
    fprintf(yyout, "\n"); // 添加换行符
}

"new" {
    //int column = yycolumn - column_start;
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s", "NEW", yytext);
    fprintf(yyout, "\n"); // 添加换行符
}

"detele" {
    //int column = yycolumn - column_start;
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s", "DELETE", yytext);
    fprintf(yyout, "\n"); // 添加换行符
}

"using" {
    //int column = yycolumn - column_start;
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s", "USING", yytext);
    fprintf(yyout, "\n"); // 添加换行符
}

"namespace" {
    //int column = yycolumn - column_start;
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s", "NAMESPACE", yytext);
    fprintf(yyout, "\n"); // 添加换行符
}   

"=" {
    //int column = yycolumn - column_start;
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s", "ASSIGN", yytext);
    fprintf(yyout, "\n"); // 添加换行符
}

"<" {
    //int column = yycolumn - column_start;
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s", "LESS", yytext);
    fprintf(yyout, "\n"); // 添加换行符
}

">" {
    //int column = yycolumn - column_start;
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s", "GREATER", yytext);
    fprintf(yyout, "\n"); // 添加换行符
}

"<=" {
    //int column = yycolumn - column_start;
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s", "LESSEQUAL", yytext);
    fprintf(yyout, "\n"); // 添加换行符
}   

">=" {
    //int column = yycolumn - column_start;
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s", "GREATEREQUAL", yytext);
    fprintf(yyout, "\n"); // 添加换行符
}   

"==" {
    //int column = yycolumn - column_start;
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s", "EQUAL", yytext);
    fprintf(yyout, "\n"); // 添加换行符
}

"!=" {
    //int column = yycolumn - column_start;
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s", "NOTEQUAL", yytext);
    fprintf(yyout, "\n"); // 添加换行符
}

"!" {
    //int column = yycolumn - column_start;
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s", "NOT", yytext);
    fprintf(yyout, "\n"); // 添加换行符
}

"&&" {
    //int column = yycolumn - column_start;
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s", "AND", yytext);
    fprintf(yyout, "\n"); // 添加换行符
}

"||" {
    //int column = yycolumn - column_start;
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s", "OR", yytext);
    fprintf(yyout, "\n"); // 添加换行符
}

"+" {
    //int column = yycolumn - column_start;
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s", "ADD", yytext);
    fprintf(yyout, "\n"); // 添加换行符
}

"-" {
    //int column = yycolumn - column_start;
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s", "SUB", yytext);
    fprintf(yyout, "\n"); // 添加换行符
}

"*" {
    //int column = yycolumn - column_start;
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s", "MUL", yytext);
    fprintf(yyout, "\n"); // 添加换行符
}

"/" {
    //int column = yycolumn - column_start;
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s", "DIV", yytext);
    fprintf(yyout, "\n"); // 添加换行符
}

"%" {
    //int column = yycolumn - column_start;
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s", "MOD", yytext);
    fprintf(yyout, "\n"); // 添加换行符
}

";" {
    //int column = yycolumn - column_start;
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s", "SEMICOLON", yytext);
    fprintf(yyout, "\n"); // 添加换行符
}

":" {
    //int column = yycolumn - column_start;
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s", "COLON", yytext);
    fprintf(yyout, "\n"); // 添加换行符
}

"," {
    //int column = yycolumn - column_start;
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s", "COMMA", yytext);
    fprintf(yyout, "\n"); // 添加换行符
}

"'" {
    //int column = yycolumn - column_start;
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s", "QUOTATION", yytext);
    fprintf(yyout, "\n"); // 添加换行符
}

"(" {
    //int column = yycolumn - column_start;
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s", "LPAREN", yytext);
    fprintf(yyout, "\n"); // 添加换行符
}

")" {
    //int column = yycolumn - column_start;
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s", "RPALEN", yytext);
    fprintf(yyout, "\n"); // 添加换行符
}

"{" {
    //int column = yycolumn - column_start;
    int start_column = yycolumn;
    yycolumn += yyleng;
    enterScope();
    dump_tokens(yylineno, start_column, "%-10s\t%s", "LBRACE", yytext);
    fprintf(yyout, "\n"); // 添加换行符
}

"}" {
    //int column = yycolumn - column_start;
    int start_column = yycolumn;
    yycolumn += yyleng;
    reduceScope();
    dump_tokens(yylineno, start_column, "%-10s\t%s", "RBRACE", yytext);
    fprintf(yyout, "\n"); // 添加换行符
}

"[" {
    //int column = yycolumn - column_start;
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s", "LBRACKET", yytext);
    fprintf(yyout, "\n"); // 添加换行符
}

"]" {
    //int column = yycolumn - column_start;
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s", "RBRACKET", yytext);
    fprintf(yyout, "\n"); // 添加换行符
}

"#" {
    //int column = yycolumn - column_start;
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s", "POUND", yytext);
    fprintf(yyout, "\n"); // 添加换行符
}

{DECIMIAL} {
    //int column = yycolumn - column_start;
    int start_column = yycolumn;
    yycolumn += yyleng;
    int decimial;
    decimial = atoi(yytext);//将十进制字符串转换为十进制整数
    dump_tokens(yylineno, start_column, "%-10s\t%s", "DECIMIAL", yytext);
    fprintf(yyout, "\t%d\n", decimial); // 添加换行符
}

{OCTAL} {
    //int column = yycolumn - column_start;
    int start_column = yycolumn;
    yycolumn += yyleng;
    int octal;
    octal = strtol(yytext, NULL, 8);//将八进制字符串转换为十进制整数
    dump_tokens(yylineno, start_column, "%-10s\t%s", "OCTAL", yytext);
    fprintf(yyout, "\t%d\n", octal); // 添加换行符
}

{HEXAL} {
    //int column = yycolumn - column_start;
    int start_column = yycolumn;
    yycolumn += yyleng;
    int hexal;
    hexal = strtol(yytext, NULL, 16);//将十六进制字符串转换为十进制整数
    dump_tokens(yylineno, start_column, "%-10s\t%s", "HEXAL", yytext);
    fprintf(yyout, "\t%d\n",hexal); // 添加换行符
}

{FLOAT} { /* 在规则部分，FLOAT被转换为浮点数并输出。*/
    int start_column = yycolumn;
    yycolumn += yyleng;
    if (strstr(yytext, "0x") || strstr(yytext, "0X")) { // 十六进制浮点数
        double hex_float;
        sscanf(yytext, "%lA", &hex_float);
        dump_tokens(yylineno, start_column, "%-10s\t%s", "HEXAL_FLOAT", yytext);
        fprintf(yyout, "\t%f\n", hex_float); // 添加换行符
    } 
    else { // 十进制浮点数
        float float_val;
        sscanf(yytext, "%f", &float_val);
        dump_tokens(yylineno, start_column, "%-10s\t%s", "FLOAT", yytext);
        fprintf(yyout, "\t%f\n", float_val); // 添加换行符
    }
}

{ID} {
    int start_column = yycolumn;
    yycolumn += yyleng;
    SymbolTable* symbol = checkSymbol(yytext);
    if(!symbol){
        addSymbol(yytext, 0, 0, stackTop);
        symbol = checkSymbol(yytext);
    }
    // 在这里，我修改了 format 字符串，将地址信息包含在其中
    dump_tokens(yylineno, start_column, "%-10s\t%s", "ID", yytext);
    fprintf(yyout, "\t%p\n", (void*)symbol); // 输出属性，例如符号表项指针
    //这里使用void强制转换，让 fprintf 函数能够以通用的方式处理指针， %p 格式说明符将指针作为地址输出
}

{EOL} {
    yylineno++;
    yycolumn = 1; // 重置列号
}

{WHITE} {
    yycolumn += yyleng; // 更新列号
}

    /*  Your code here (lab3). */

{LINECOMMENT} {
    yylineno++;
    yycolumn = 1; // 重置列号
}

{COMMENTBEGIN} {
    BEGIN(BLOCKCOMMENT);
}

<BLOCKCOMMENT>{COMMENTEOL} {
    yylineno++;
    yycolumn = 1; // 重置列号
}

<BLOCKCOMMENT>{COMMENTELEMENT} {
    //yycolumn++; // 更新列号
    yycolumn += yyleng; // 更新列号，根据匹配到的字符长度
}

<BLOCKCOMMENT>{COMMENTEND} {
    BEGIN(INITIAL);//恢复到初始状态
    yycolumn += 2; // "*/" 两个字符
}

%%
/* user code section */

//添加符号到符号表
void addSymbol(char* name, int type, int value,int scope){
    if(checkSymbol(name)){
        fprintf(stderr, "symbol %s already exists\n", name);
        exit(1);
    }
    SymbolTable* symbol = (SymbolTable*)malloc(sizeof(SymbolTable));
    if(!symbol){
        fprintf(stderr, "malloc failed\n");
        exit(1);
    }
    symbol->name = strdup(name); // 使用strdup复制字符串
    symbol->type = type;
    symbol->value = value;
    symbol->scope = scope;
    symbol->next = symbolTableStack[stackTop];
    symbolTableStack[stackTop] = symbol;//插入，更改数组元素
    /**
     * 这里使用链表来构建栈，因此使用头插法，在符号表栈的顶部进行维护
     * 这样使得最新的符号表项总是在栈顶，适合于作用域的查找，同时不需要遍历整个链表
     */
}

//检查符号是否已经在符号表中，查询标识符
SymbolTable* checkSymbol(char* name){
    /**
     * 由于没有对于语句和函数块进行区别，在现在的实现中，如果当前作用域没有的话，就会去上一个作用域查找
     */
    for(int i = stackTop; i >= 0; i--){//从当前作用域开始查找
        SymbolTable* symbol = symbolTableStack[i];
        while(symbol)
        {
            if(strcmp(symbol->name, name) == 0){
                return symbol;
            } 
            symbol = symbol->next;
        }
    }
    return NULL;
}

//当进入新的作用域中增加作用域
void enterScope(){
    stackTop++;
    symbolTableStack[stackTop] = NULL; //为新的作用域创建符号表
}

//当离开作用域时减少作用域
void reduceScope(){
    stackTop--;//pop
}