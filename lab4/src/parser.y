%code top{
    #include <iostream>
    #include <assert.h>
    #include "parser.h"
    extern Ast ast;
    int yylex();
    int yyerror( char const * );

    Type* currentType;
}

%code requires {
    #include "Ast.h"
    #include "SymbolTable.h"
    #include "Type.h"
}

%union {
    int itype;
    float ftype;
    char* strtype;
    StmtNode* stmttype;
    ExprNode* exprtype;
    Type* type;
}

%start Program
%token <strtype> ID 
%token <itype> INTEGER
%token <ftype> FLOATING
%token CONST
%token IF ELSE WHILE BREAK CONTINUE
%token INT VOID FLOAT
%token LPAREN RPAREN LBRACE RBRACE SEMICOLON LBRACKET RBRACKET COMMA
%token ADD SUB MUL DIV MOD AND OR NOT LESS LESSEQUAL GREATER GREATEREQUAL EQUAL NOTEQUAL ASSIGN
%token RETURN

%type <stmttype> Stmts Stmt AssignStmt ExpStmt BlockStmt IfStmt WhileStmt BreakStmt ContinueStmt ReturnStmt
%type <stmttype> DeclStmt ConstDefList ConstDef ConstInitVal VarDefList VarDef VarInitVal FuncDef FuncParams FuncParam FuncRParams
%type <stmttype> ArrConstIndices ArrValIndices ConstInitValList VarInitValList
%type <exprtype> Exp ConstExp AddExp MulExp UnaryExp PrimaryExp LVal Cond LOrExp LAndExp EqExp RelExp
%type <type> Type

%precedence THEN
%precedence ELSE
%%
//程序
Program
    : Stmts {
        ast.setRoot($1);
    }
    ;

//语句序列
Stmts
    : Stmt {
       
        $$ = $1;
    }
    | Stmts Stmt{
        $$ = new SeqNode($1,$2);
    }
    ;

//语句
Stmt
    : AssignStmt {$$=$1;}
    | ExpStmt SEMICOLON {$$=$1;}
    | BlockStmt {$$=$1;}
    | IfStmt {$$=$1;}
    | WhileStmt {$$=$1;}
    | BreakStmt {$$=$1;}
    | ContinueStmt {$$=$1;}
    | ReturnStmt {$$=$1;}
    | DeclStmt {$$=$1;}
    | FuncDef {$$=$1;}
    | SEMICOLON {$$ = new EmptyStmt();}
    ;

//左值
LVal
    : ID {
        SymbolEntry *se;
        se = identifiers->lookup($1);
        if(se == nullptr)
        {
            fprintf(stderr, "identifier \"%s\" is undefined\n", (char*)$1);
            delete [](char*)$1;
            assert(se != nullptr);
        }
        $$ = new Id(se);
        delete []$1;
    }
    | ID ArrValIndices {
        SymbolEntry *se;
        se = identifiers->lookup($1);
        if(se == nullptr)
        {
            fprintf(stderr, "identifier \"%s\" is undefined\n", (char*)$1);
            delete [](char*)$1;
            assert(se != nullptr);
        }
        Id *newId = new Id(se);
        newId->addIndices((ExprStmtNode*)$2);
        $$ = newId;
        delete []$1;
    }
    ;

//赋值语句
AssignStmt
    :
    LVal ASSIGN Exp SEMICOLON {
        $$ = new AssignStmt($1, $3);
    }
    ;

//表达式语句
ExpStmt
    :
    Exp {
        ExprStmtNode* node = new ExprStmtNode();
        node->addNext($1);
        $$ = node;
    }
    |
    ExpStmt COMMA Exp {
        ExprStmtNode* node = (ExprStmtNode*)$1;
        node->addNext($3);
        $$ = node;
    }
    ;

//语句块
BlockStmt
    :   LBRACE 
        {identifiers = new SymbolTable(identifiers);} 
        Stmts RBRACE 
        {
            $$ = new CompoundStmt($3);
            SymbolTable *top = identifiers;
            identifiers = identifiers->getPrev();
            delete top;
        }
    |   LBRACE RBRACE {
            $$ = new CompoundStmt(nullptr);
        }
    ;

// if语句
IfStmt
    : IF LPAREN Cond RPAREN Stmt %prec THEN {
        $$ = new IfStmt($3, $5);
    }
    | IF LPAREN Cond RPAREN Stmt ELSE Stmt {
        $$ = new IfElseStmt($3, $5, $7);
    }
    ;

//while 语句
WhileStmt
    : WHILE LPAREN Cond RPAREN Stmt {
        $$ = new WhileStmt($3, $5);
    }
    ;

//break语句
BreakStmt
    : BREAK SEMICOLON {
        $$ = new BreakStmt();
    }
    ;

//continue语句
ContinueStmt
    : CONTINUE SEMICOLON {
        $$ = new ContinueStmt();
    }
    ;

//return语句
ReturnStmt
    :
    RETURN Exp SEMICOLON{
        $$ = new ReturnStmt($2);
    }
    |
    RETURN SEMICOLON{
        $$ = new ReturnStmt(nullptr);
    }
    ;

//变量表达式
Exp
    :
    AddExp {$$ = $1;}
    ;

//常量表达式  
ConstExp
    :
    AddExp {$$ = $1;}
    ;

//加法级表达式
AddExp
    :
    MulExp {$$ = $1;}
    |
    AddExp ADD MulExp {
        SymbolEntry *se;
        if($1->getType()->isInt() && $3->getType()->isInt()){
            se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        }
        else{
            se = new TemporarySymbolEntry(TypeSystem::floatType, SymbolTable::getLabel());
        }
        $$ = new BinaryExpr(se, BinaryExpr::ADD, $1, $3);
    }
    |
    AddExp SUB MulExp {
            SymbolEntry *se;
            if($1->getType()->isInt() && $3->getType()->isInt()){
                se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
            }
            else{
                se = new TemporarySymbolEntry(TypeSystem::floatType, SymbolTable::getLabel());
            }
        $$ = new BinaryExpr(se, BinaryExpr::SUB, $1, $3);
    }
    ;

//乘法级表达式
MulExp
    :
    UnaryExp {$$ = $1;}
    |
    MulExp MUL UnaryExp {
        SymbolEntry *se;
        if($1->getType()->isInt() && $3->getType()->isInt()){
            se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        }
        else{
            se = new TemporarySymbolEntry(TypeSystem::floatType, SymbolTable::getLabel());
        }
        $$ = new BinaryExpr(se, BinaryExpr::MUL, $1, $3);
    }
    |
    MulExp DIV UnaryExp {
        SymbolEntry *se;
        if($1->getType()->isInt() && $3->getType()->isInt()){
            se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        }
        else{
            se = new TemporarySymbolEntry(TypeSystem::floatType, SymbolTable::getLabel());
        }
        $$ = new BinaryExpr(se, BinaryExpr::DIV, $1, $3);
    }
    |
    MulExp MOD UnaryExp {
        SymbolEntry *se;
        if($1->getType()->isInt() && $3->getType()->isInt()){
            se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        }
        else{
            se = new TemporarySymbolEntry(TypeSystem::floatType, SymbolTable::getLabel());
        }
        $$ = new BinaryExpr(se, BinaryExpr::MOD, $1, $3);
    }
    ;

//非数组表达式
UnaryExp
    :
    PrimaryExp {$$ = $1;}
    |
    ID LPAREN FuncRParams RPAREN {
        SymbolEntry *se;
        se = identifiers->lookup($1);
        if(se == nullptr)
        {
            fprintf(stderr, "identifier \"%s\" is undefined\n", (char*)$1);
            delete [](char*)$1;
            assert(se != nullptr);
        }
        SymbolEntry *tmp = new TemporarySymbolEntry(se->getType(), SymbolTable::getLabel());
        $$ = new FuncCallNode(tmp, new Id(se), (FuncCallParamsNode*)$3);
    }
    |
    ADD UnaryExp {
        $$ = $2;
    }
    |
    SUB UnaryExp {
        SymbolEntry *tmp = new TemporarySymbolEntry($2->getType(), SymbolTable::getLabel());
        $$ = new OneOpExpr(tmp, OneOpExpr::SUB, $2);
    }
    |
    NOT UnaryExp {
        SymbolEntry *tmp = new TemporarySymbolEntry($2->getType(), SymbolTable::getLabel());
        $$ = new OneOpExpr(tmp, OneOpExpr::NOT, $2);
    }
    ;

//条件表达式
Cond
    :
    LOrExp {$$ = $1;}
    ;

//原始表达式
PrimaryExp
    :
    LVal {
        $$ = $1;
    }
    | LPAREN Exp RPAREN {
        $$ = $2;
    }
    | INTEGER {
        SymbolEntry *se = new ConstantSymbolEntry(TypeSystem::intType, $1);
        $$ = new Constant(se);
    }
    | FLOATING {
        SymbolEntry *se = new ConstantSymbolEntry(TypeSystem::floatType, $1);
        $$ = new Constant(se);
    }
    ;

//关系运算表达式
RelExp
    :
    AddExp {$$ = $1;}
    |
    RelExp LESS AddExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::boolType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::LESS, $1, $3);
    }
    |
    RelExp LESSEQUAL AddExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::boolType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::LESSEQUAL, $1, $3);
    }
    |
    RelExp GREATER AddExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::boolType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::GREATER, $1, $3);
    }
    |
    RelExp GREATEREQUAL AddExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::boolType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::GREATEREQUAL, $1, $3);
    }
    ;

//与运算表达式
LAndExp
    :
    EqExp {$$ = $1;}
    |
    LAndExp AND EqExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::boolType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::AND, $1, $3);
    }
    ;

//或运算
LOrExp
    :
    LAndExp {$$ = $1;}
    |
    LOrExp OR LAndExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::boolType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::OR, $1, $3);
    }
    ;

//相等运算表达式
EqExp
    :
    RelExp {$$ = $1;}
    |
    EqExp EQUAL RelExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::boolType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::EQUAL, $1, $3);
    }
    |
    EqExp NOTEQUAL RelExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::boolType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::NOTEQUAL, $1, $3);
    }
    ;

//类型
Type
    : INT {
        $$ = TypeSystem::intType;
        currentType = TypeSystem::intType;
    }
    | VOID {
        $$ = TypeSystem::voidType;
    }
    | FLOAT {
        $$ = TypeSystem::floatType;
        currentType = TypeSystem::floatType;
    }
    ;

//数组常量下标表示
ArrConstIndices
    :
    LBRACKET ConstExp RBRACKET {
        ExprStmtNode* node = new ExprStmtNode();
        node->addNext($2);
        $$ = node;
    }
    |
    ArrConstIndices LBRACKET ConstExp RBRACKET {
        ExprStmtNode* node = (ExprStmtNode*)$1;
        node->addNext($3);
        $$ = node;
    }
    ;

//数组的变量下标表示
ArrValIndices
    :
    LBRACKET Exp RBRACKET {
        ExprStmtNode* node = new ExprStmtNode();
        node->addNext($2);
        $$ = node;
    }
    |
    ArrValIndices LBRACKET Exp RBRACKET {
        ExprStmtNode* node = (ExprStmtNode*)$1;
        node->addNext($3);
        $$ = node;
    }
    ;

//声明语句
DeclStmt
    :
    Type VarDefList SEMICOLON {
        $$ = $2;
    }
    |
    CONST Type ConstDefList SEMICOLON {
        $$ = $3;
    }
    ;

//常量定义列表
ConstDefList
    :
    ConstDef {
        DeclStmt* node = new DeclStmt(true);
        node->addNext((DefNode*)$1);
        $$ = node;
    }
    |
    ConstDefList COMMA ConstDef {
        DeclStmt* node = (DeclStmt*)$1;
        node->addNext((DefNode*)$3);
        $$ = node;
    }
    ;

//常量定义
ConstDef
    :
    ID ArrConstIndices ASSIGN ConstInitVal {
        // 首先将ID插入符号表中
        Type* type;
        if(currentType->isInt()){
            type = new ConstIntArrayType();
        }
        else{
            type = new ConstFloatArrayType();
        }
        SymbolEntry *se;
        se = new IdentifierSymbolEntry(type, $1, identifiers->getLevel());
        identifiers->install($1, se);
        Id* id = new Id(se);
        id->addIndices((ExprStmtNode*)$2);
        $$ = new DefNode(id, (Node*)$4, true, true);//类型向上转换
    }
    |
    ID ASSIGN ConstExp {
        // 首先将ID插入符号表中
        Type* type;
        if(currentType->isInt()){
            type = TypeSystem::constIntType;
        }
        else{
            type = TypeSystem::constFloatType;
        }
        SymbolEntry *se;
        se = new IdentifierSymbolEntry(type, $1, identifiers->getLevel());
        identifiers->install($1, se);
        $$ = new DefNode(new Id(se), (Node*)$3, true, false);//类型向上转换
    }
    ;

//常量初始化
ConstInitVal
    :
    ConstExp { //不能直接赋值 $$ = $1 无法判断是list还是expr
        InitValNode* newNode = new InitValNode(true);
        newNode->setLeafNode((ExprNode*)$1);
        $$ = newNode;
    }
    | LBRACE ConstInitValList RBRACE {
        $$ = $2;
    }
    | LBRACE RBRACE {
        $$ = new InitValNode(true);
    }
    ;

//数组常量初始化列表
ConstInitValList
    :
    ConstInitVal {
        InitValNode* node = new InitValNode(true);
        node->addNext((InitValNode*)$1);
        $$ = node;
    }
    |
    ConstInitValList COMMA ConstInitVal {
        InitValNode* node = (InitValNode*)$1;
        node->addNext((InitValNode*)$3);
        $$ = node;
    }
    ;

//变量定义列表
VarDefList
    :
    VarDef {
        DeclStmt* node = new DeclStmt(true);
        node->addNext((DefNode*)$1);
        $$ = node;
    }
    |
    VarDefList COMMA VarDef {
        DeclStmt* node = (DeclStmt*)$1;
        node->addNext((DefNode*)$3);
        $$ = node;
    }
    ;

//变量定义
VarDef
    :
    ID ArrConstIndices {
        // 首先将ID插入符号表中
        Type* type;
        if(currentType->isInt()){
            type = new IntArrayType();
        }
        else{
            type = new FloatArrayType();
        }
        SymbolEntry *se;
        se = new IdentifierSymbolEntry(type, $1, identifiers->getLevel());
        identifiers->install($1, se);
        Id* id = new Id(se);
        id->addIndices((ExprStmtNode*)$2);
        $$ = new DefNode(id, nullptr, false, true);
    }
    |
    ID ArrConstIndices ASSIGN VarInitVal {
        // 首先将ID插入符号表中
        Type* type;
        if(currentType->isInt()){
            type = new IntArrayType();
        }
        else{
            type = new FloatArrayType();
        }
        SymbolEntry *se;
        se = new IdentifierSymbolEntry(type, $1, identifiers->getLevel());
        identifiers->install($1, se);
        Id* id = new Id(se);
        id->addIndices((ExprStmtNode*)$2);
        $$ = new DefNode(id, (Node*)$4, false, true);
    }
    |
    ID ASSIGN Exp {
        // 首先将ID插入符号表中
        Type* type;
        if(currentType->isInt()){
            type = TypeSystem::intType;
        }
        else{
            type = TypeSystem::floatType;
        }
        SymbolEntry *se;
        se = new IdentifierSymbolEntry(type, $1, identifiers->getLevel());
        identifiers->install($1, se);
        $$ = new DefNode(new Id(se), (Node*)$3, false, false);
    }
    |
    ID {
        // 首先将ID插入符号表中
        Type* type;
        if(currentType->isInt()){
            type = TypeSystem::intType;
        }
        else{
            type = TypeSystem::floatType;
        }
        SymbolEntry *se;
        se = new IdentifierSymbolEntry(type, $1, identifiers->getLevel());
        identifiers->install($1, se);
        $$ = new DefNode(new Id(se), nullptr, false, false);
    }
    ;

//变量初始化值
VarInitVal
    :
    Exp {
        InitValNode* newNode = new InitValNode(false);
        newNode->setLeafNode((ExprNode*)$1);
        $$ = newNode;
    }
    | LBRACE VarInitValList RBRACE {
        $$ = $2;
    }
    | LBRACE RBRACE {
        $$ = new InitValNode(false);
    }
    ;

//数组变量初始化列表
VarInitValList
    :
    VarInitVal {
        InitValNode* node = new InitValNode(false);
        node->addNext((InitValNode*)$1);
        $$ = node;
    }
    |
    VarInitValList COMMA VarInitVal {
        InitValNode* node = (InitValNode*)$1;
        node->addNext((InitValNode*)$3);
        $$ = node;
    }
    ;

//函数参数列表
FuncRParams
    :
    Exp {
        FuncCallParamsNode* node = new FuncCallParamsNode();
        node->addNext($1);
        $$ = node;
    }
    |
    FuncRParams COMMA Exp {
        FuncCallParamsNode* node = (FuncCallParamsNode*)$1;
        node->addNext($3);
        $$ = node;
    }
    |
    %empty {
        $$ = nullptr;
    }
    ;

//函数定义
FuncDef
    :
    Type ID {
        Type *funcType;
        funcType = new FunctionType($1,{});
        SymbolEntry *se = new IdentifierSymbolEntry(funcType, $2, identifiers->getLevel());
        identifiers->install($2, se);
        identifiers = new SymbolTable(identifiers);
    }
    LPAREN FuncParams{
        SymbolEntry *se;
        se = identifiers->lookup($2);
        assert(se != nullptr);
        if($5!=nullptr){
            //将函数参数类型写入符号表
            ((FunctionType*)(se->getType()))->setparamsType(((FuncDefParamsNode*)$5)->getParamsType());
        }   
    }
    RPAREN BlockStmt {
        SymbolEntry *se;
        se = identifiers->lookup($2);
        assert(se != nullptr);
        $$ = new FunctionDef(se, (FuncDefParamsNode*)$5, $8);
        SymbolTable *top = identifiers;
        identifiers = identifiers->getPrev();
        delete top;
        delete []$2;
    }
    ;

//函数参数列表
FuncParams
    :
    FuncParam {
        FuncDefParamsNode* node = new FuncDefParamsNode();
        node->addNext(((DefNode*)$1)->getId());
        $$ = node;
    }
    |
    FuncParams COMMA FuncParam {
        FuncDefParamsNode* node = (FuncDefParamsNode*)$1;
        node->addNext(((DefNode*)$3)->getId());
        $$ = node;
    }
    |
    %empty {
        $$ = nullptr;
    }
    ;

// 函数参数
FuncParam
    :   Type ID {
            SymbolEntry *se = new IdentifierSymbolEntry($1, $2, identifiers->getLevel());
            identifiers->install($2, se);
            $$ = new DefNode(new Id(se), nullptr, false, false);
        }
    //数组函数参数
    |   Type ID LBRACKET RBRACKET ArrConstIndices{
            Type* arrayType = nullptr; 
            if($1==TypeSystem::intType){
                arrayType = new IntArrayType();
                ((IntArrayType*)arrayType)->pushBackDimension(-1);
            }
            else if($1==TypeSystem::floatType){
                arrayType = new FloatArrayType();
                ((FloatArrayType*)arrayType)->pushBackDimension(-1);
            }
            //最高维未指定，记为默认值-1
            SymbolEntry *se = new IdentifierSymbolEntry(arrayType, $2, identifiers->getLevel());
            identifiers->install($2, se);
            Id* id = new Id(se);
            id->addIndices((ExprStmtNode*)$5);
            $$ = new DefNode(id, nullptr, false, true);
        }
    |   Type ID LBRACKET RBRACKET{
            Type* arrayType = nullptr; 
            if($1==TypeSystem::intType){
                arrayType = new IntArrayType();
                ((IntArrayType*)arrayType)->pushBackDimension(-1);
            }
            else if($1==TypeSystem::floatType){
                arrayType = new FloatArrayType();
                ((FloatArrayType*)arrayType)->pushBackDimension(-1);
            }
            //最高维未指定，记为默认值-1
            SymbolEntry *se = new IdentifierSymbolEntry(arrayType, $2, identifiers->getLevel());
            identifiers->install($2, se);
            Id* id = new Id(se);
            $$ = new DefNode(id, nullptr, false, true);
        }
    ;
    
%%

int yyerror(char const* message)
{
    std::cerr<<message<<std::endl;
    return -1;
}
