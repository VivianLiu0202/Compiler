%option noyywrap
%option nounput
%option noinput
%top{
    #include <stdarg.h>
    #include <stdio.h>
    #include <string.h>
    #include <parser.h>
    #include "SymbolTable.h"
    #include "common.h"
}
%{
    //int column_start = 0;
    int yycolumn = 1; //初始化列号
    extern dump_type_t dump_type;
    //dump_tokens 函数现在接收行号和列号作为参数，并在输出中包含它们
    //该函数接受可变参数列表（由...表示），允许以自定义格式输出信息。
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

%}

/* definitions section */
/*  Your code here (lab3). */
INTEGER ([1-9][0-9]*|0)
OCTAL (0[1-7][0-7]*|0)
HEXAL (0(x|X)[1-9a-fA-F][0-9a-fA-F]*|0)
FLOATING (([0-9]*"."[0-9]+([eE][-+]?[0-9]+)?)|0[xX][0-9a-fA-F]+(\.[0-9a-fA-F]+)?([pP][-+]?[0-9]+)?)
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
    int start_column = yycolumn; // 保存token开始的列号
    yycolumn += yyleng; // 更新列号
    dump_tokens(yylineno, start_column, "%-10s\t%s", "INT", yytext);
    return INT;
}

"float" {
    int start_column = yycolumn; // 保存token开始的列号
    yycolumn += yyleng; // 更新列号
    dump_tokens(yylineno, start_column, "%-10s\t%s", "FLOAT", yytext);
    return FLOAT;
}

"void" {
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s", "VOID", yytext);
    return VOID;
    
}

"if" {
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s", "IF", yytext); 
    return IF;
}

"else" {
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s", "ELSE", yytext);
    return ELSE;
}
"while" {
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s", "WHILE", yytext);
    return WHILE;
}
"return" {
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s", "RETURN", yytext);
    return RETURN;
}

"const" {
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s", "CONST", yytext);
    return CONST;
}

"break" {
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s", "BREAK", yytext);
    return BREAK;
}

"continue" {
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s", "CONTINUE", yytext);
    return CONTINUE;
}  

"=" {
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s", "ASSIGN", yytext);
    return ASSIGN;
}

"<" {
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s", "LESS", yytext);
    return LESS;
}

">" {
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s", "GREATER", yytext);
    return GREATER;
}

"<=" {
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s", "LESSEQUAL", yytext);
    return LESSEQUAL;
}   

">=" {
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s", "GREATEREQUAL", yytext);
    return GREATEREQUAL;
}   

"==" {
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s", "EQUAL", yytext);
    return EQUAL;
}

"!=" {
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s", "NOTEQUAL", yytext);
    return NOTEQUAL;
}

"!" {
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s", "NOT", yytext);
    return NOT;
}

"&&" {
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s", "AND", yytext);
    return AND;
}

"||" {
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s", "OR", yytext);
    return OR;
}

"+" {
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s", "ADD", yytext);
    return ADD;
}

"-" {
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s", "SUB", yytext);
    return SUB;
}

"*" {
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s", "MUL", yytext);
    return MUL;
}

"/" {
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s", "DIV", yytext);
    return DIV;
}

"%" {
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s", "MOD", yytext);
    return MOD;
}

";" {
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s", "SEMICOLON", yytext);
    return SEMICOLON;
}

"," {
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s", "COMMA", yytext);
    return COMMA;
}

"(" {
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s", "LPAREN", yytext);
    return LPAREN;
}

")" {
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s", "RPALEN", yytext);
    return RPAREN;
}

"{" {
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s", "LBRACE", yytext);
    return LBRACE;
}

"}" {
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s", "RBRACE", yytext);
    return RBRACE;
}

"[" {
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s", "LBRACKET", yytext);
    return LBRACKET;
}

"]" {
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s", "RBRACKET", yytext);
    return RBRACKET;
}


"getint" {
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s\n", "ID", yytext);

    char *lexeme = new char[strlen(yytext) + 1];
    strcpy(lexeme, yytext);
    yylval.strtype = lexeme;
    Type* funcType = new FunctionType(TypeSystem::intType, {});//返回类型int，无参数
    SymbolTable* globalTable;    //全域符号表
    for(globalTable = identifiers; globalTable->getPrev(); globalTable = globalTable->getPrev()); //全域符号表
    SymbolEntry* entry = new IdentifierSymbolEntry(funcType, yytext, 0);//作用域GLOBAL(0)
    globalTable->install(yytext, entry);
    return ID;
}

"getch" {
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s\n", "ID", yytext);

    char *lexeme = new char[strlen(yytext) + 1];
    strcpy(lexeme, yytext);
    yylval.strtype = lexeme;
    Type* funcType = new FunctionType(TypeSystem::intType, {});//返回类型int，无参数
    SymbolTable* globalTable;    //全域符号表
    for(globalTable = identifiers;globalTable->getPrev();globalTable = globalTable->getPrev()); //全域符号表
    SymbolEntry* entry = new IdentifierSymbolEntry(funcType, yytext, 0);//作用域GLOBAL(0)
    globalTable->install(yytext, entry);
    return ID;
}

"getfloat" {
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s\n", "ID", yytext);

    char *lexeme = new char[strlen(yytext) + 1];
    strcpy(lexeme, yytext);
    yylval.strtype = lexeme;
    Type* funcType = new FunctionType(TypeSystem::floatType, {});//返回类型int，无参数
    SymbolTable* globalTable;    //全域符号表
    for(globalTable = identifiers;globalTable->getPrev();globalTable = globalTable->getPrev()); //全域符号表
    SymbolEntry* entry = new IdentifierSymbolEntry(funcType, yytext, 0);//作用域GLOBAL(0)
    globalTable->install(yytext, entry);
    return ID;
}

"getarray" {
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s\n", "ID", "getarray");

    char *lexeme = new char[strlen(yytext) + 1];
    strcpy(lexeme, yytext);
    yylval.strtype = lexeme;
    std::vector<Type*> vec; //形参类型表
    Type* arrayType = new IntArrayType();
    ((IntArrayType*)arrayType)->pushBackDimension(-1);
    vec.push_back(arrayType);
    Type* funcType = new FunctionType(TypeSystem::intType, vec);//返回类型int，参数[int array]
    SymbolTable* globalTable;    //全域符号表
    for(globalTable = identifiers;globalTable->getPrev();globalTable = globalTable->getPrev()); //全域符号表
    SymbolEntry* entry = new IdentifierSymbolEntry(funcType, yytext, 0);//作用域GLOBAL(0)
    globalTable->install(yytext, entry);
    return ID;
}

"getfarray" {
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s\n", "ID", "getfarray");

    char *lexeme = new char[strlen(yytext) + 1];
    strcpy(lexeme, yytext);
    yylval.strtype = lexeme;
    std::vector<Type*> vec; //形参类型表
    Type* arrayType = new FloatArrayType();
    ((FloatArrayType*)arrayType)->pushBackDimension(-1);
    vec.push_back(arrayType);
    Type* funcType = new FunctionType(TypeSystem::intType, vec);//返回类型int，参数[float array]
    SymbolTable* globalTable;    //全域符号表
    for(globalTable = identifiers;globalTable->getPrev();globalTable = globalTable->getPrev()); //全域符号表
    SymbolEntry* entry = new IdentifierSymbolEntry(funcType, yytext, 0);//作用域GLOBAL(0)
    globalTable->install(yytext, entry);
    return ID;
}

"putint" {
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s\n", "ID", "putint");

    char *lexeme = new char[strlen(yytext) + 1];
    strcpy(lexeme, yytext);
    yylval.strtype = lexeme;
    std::vector<Type*> vec; //形参类型表
    vec.push_back(TypeSystem::intType);
    Type* funcType = new FunctionType(TypeSystem::voidType, vec);//返回类型void，参数表[int]
    SymbolTable* globalTable;    //全域符号表
    for(globalTable = identifiers;globalTable->getPrev();globalTable = globalTable->getPrev()); //全域符号表
    SymbolEntry* entry = new IdentifierSymbolEntry(funcType, yytext, 0);//作用域GLOBAL(0)
    globalTable->install(yytext, entry);
    return ID;
}

"putch" {
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s\n", "ID", "putch");

    char *lexeme = new char[strlen(yytext) + 1];
    strcpy(lexeme, yytext);
    yylval.strtype = lexeme;
    std::vector<Type*> vec; //形参类型表
    vec.push_back(TypeSystem::intType);
    Type* funcType = new FunctionType(TypeSystem::voidType, vec);//返回类型void，参数表[int]
    SymbolTable* globalTable;    //全域符号表
    for(globalTable = identifiers;globalTable->getPrev();globalTable = globalTable->getPrev()); //全域符号表
    SymbolEntry* entry = new IdentifierSymbolEntry(funcType, yytext, 0);//作用域GLOBAL(0)
    globalTable->install(yytext, entry);
    return ID;
}

"putfloat" {
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s\n", "ID", "putfloat");   

    char *lexeme = new char[strlen(yytext) + 1];
    strcpy(lexeme, yytext);
    yylval.strtype = lexeme;
    std::vector<Type*> vec; //形参类型表
    vec.push_back(TypeSystem::floatType);
    Type* funcType = new FunctionType(TypeSystem::voidType, vec);//返回类型void，参数表[int]
    SymbolTable* globalTable;    //全域符号表
    for(globalTable = identifiers;globalTable->getPrev();globalTable = globalTable->getPrev()); //全域符号表
    SymbolEntry* entry = new IdentifierSymbolEntry(funcType, yytext, 0);//作用域GLOBAL(0)
    globalTable->install(yytext, entry);
    return ID;
}

"putarray" {
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s\n", "ID", "putarray");  

    char *lexeme = new char[strlen(yytext) + 1];
    strcpy(lexeme, yytext);
    yylval.strtype = lexeme;
    std::vector<Type*> vec; //形参类型表
    vec.push_back(TypeSystem::intType);
    Type* arrayType = new IntArrayType();
    ((IntArrayType*)arrayType)->pushBackDimension(-1);
    vec.push_back(arrayType);
    Type* funcType = new FunctionType(TypeSystem::voidType, vec);//返回类型void，参数表[int, int array]
    SymbolTable* globalTable;    //全域符号表
    for(globalTable = identifiers;globalTable->getPrev();globalTable = globalTable->getPrev()); //全域符号表
    SymbolEntry* entry = new IdentifierSymbolEntry(funcType, yytext, 0);//作用域GLOBAL(0)
    globalTable->install(yytext, entry);
    return ID;
}

"putfarray" {
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s\n", "ID", "putfarray");   

    char *lexeme = new char[strlen(yytext) + 1];
    strcpy(lexeme, yytext);
    yylval.strtype = lexeme;
    std::vector<Type*> vec; //形参类型表
    vec.push_back(TypeSystem::intType);
    Type* arrayType = new FloatArrayType();
    ((FloatArrayType*)arrayType)->pushBackDimension(-1);
    vec.push_back(arrayType);
    Type* funcType = new FunctionType(TypeSystem::voidType, vec);//返回类型void，参数表[int, float array]
    SymbolTable* globalTable;    //全域符号表
    for(globalTable = identifiers;globalTable->getPrev();globalTable = globalTable->getPrev()); //全域符号表
    SymbolEntry* entry = new IdentifierSymbolEntry(funcType, yytext, 0);//作用域GLOBAL(0)
    globalTable->install(yytext, entry);
    return ID;
}

"starttime" {
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s\n", "ID", "starttime");

    char *lexeme = new char[strlen(yytext) + 1];
    strcpy(lexeme, yytext);
    yylval.strtype = lexeme;
    Type* funcType = new FunctionType(TypeSystem::voidType, {});//返回类型void，无参数
    SymbolTable* globalTable;    //全域符号表
    for(globalTable = identifiers;globalTable->getPrev();globalTable = globalTable->getPrev()); //全域符号表
    SymbolEntry* entry = new IdentifierSymbolEntry(funcType, yytext, 0);//作用域GLOBAL(0)
    globalTable->install(yytext, entry);
    return ID;
}

"stoptime" {
    int start_column = yycolumn;
    yycolumn += yyleng;
    dump_tokens(yylineno, start_column, "%-10s\t%s\n", "ID", "stoptime"); 

    char *lexeme = new char[strlen(yytext) + 1];
    strcpy(lexeme, yytext);
    yylval.strtype = lexeme;
    Type* funcType = new FunctionType(TypeSystem::voidType, {});//返回类型void，无参数
    SymbolTable* globalTable;    //全域符号表
    for(globalTable = identifiers;globalTable->getPrev();globalTable = globalTable->getPrev()); //全域符号表
    SymbolEntry* entry = new IdentifierSymbolEntry(funcType, yytext, 0);//作用域GLOBAL(0)
    globalTable->install(yytext, entry);
    return ID;

}


{INTEGER} {
    int start_column = yycolumn;
    yycolumn += yyleng;
    int decimial = atoi(yytext);//将十进制字符串转换为十进制整数
    dump_tokens(yylineno, start_column, "%-10s\t%s", "INTEGER", yytext);
    yylval.itype = decimial;
    return INTEGER;
}

{OCTAL} {
    int start_column = yycolumn;
    yycolumn += yyleng;
    int octal = strtol(yytext, NULL, 8);//将八进制字符串转换为十进制整数
    dump_tokens(yylineno, start_column, "%-10s\t%s", "OCTAL", yytext);
    yylval.itype = octal;
    return INTEGER;

}

{HEXAL} {
    int start_column = yycolumn;
    yycolumn += yyleng;
    int hexal = strtol(yytext, NULL, 16);//将十六进制字符串转换为十进制整数
    dump_tokens(yylineno, start_column, "%-10s\t%s", "HEXAL", yytext);
    yylval.itype = hexal;
    return INTEGER;
}

{FLOATING} { /* 在规则部分，FLOAT被转换为浮点数并输出。*/
    int start_column = yycolumn;
    yycolumn += yyleng;
    if (strstr(yytext, "0x") || strstr(yytext, "0X")) { // 十六进制浮点数
        double hex_float;
        sscanf(yytext, "%lA", &hex_float);
        dump_tokens(yylineno, start_column, "%-10s\t%s", "HEXAL_FLOAT", yytext);
        yylval.ftype = hex_float;
    } 
    else { // 十进制浮点数
        float float_val;
        sscanf(yytext, "%f", &float_val);
        dump_tokens(yylineno, start_column, "%-10s\t%s", "FLOAT", yytext);
        yylval.ftype = float_val;
    }
    return FLOATING;
}

{ID} {
    int start_column = yycolumn;
    yycolumn += yyleng;
    // 在这里，我修改了 format 字符串，将地址信息包含在其中
    dump_tokens(yylineno, start_column, "%-10s\t%s", "ID", yytext);
    //这里使用void强制转换，让 fprintf 函数能够以通用的方式处理指针， %p 格式说明符将指针作为地址输出
    char *lexeme = new char[strlen(yytext) + 1];
    strcpy(lexeme, yytext);
    yylval.strtype = lexeme;
    return ID;
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
    yycolumn += yyleng; // 更新列号，根据匹配到的字符长度
}

<BLOCKCOMMENT>{COMMENTEND} {
    BEGIN(INITIAL);//恢复到初始状态
    yycolumn += 2; // "*/" 两个字符
}

%%
/* user code section */