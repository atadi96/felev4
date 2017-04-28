%baseclass-preinclude "semantics.h"
%lsp-needed

%token PROGRAM TBEGIN SKIP END
%token NATURAL BOOLEAN
%token TRUE FALSE
%token NOT
%token IF THEN ELSE ENDIF
%token WHILE FOR IN RANGE DO DONE
%token READ WRITE
%token LEFT_BRACKET RIGHT_BRACKET
%token ASSIGN
%token SEMICOLON
%token NATURAL_LITERAL
%token <szoveg> IDENTIFIER

%left AND OR
%left EQUALS
%left LESS_THAN GREATER_THAN
%left PLUS MINUS
%left ASTERIKS DIV MOD

%type <var_type> expr;

%union
{
  std::string *szoveg;
  type* var_type;
}

%%

start: program
    {
        //std::cout << "start -> program" << std::endl;
    }
;
    
program: header declarations body
    {
        //std::cout << "program -> header declarations body" << std::endl;
    }
;
    
header: PROGRAM IDENTIFIER
    {
        //std::cout << "header -> PROGRAM IDENTIFIER" << std::endl;
    }
;
    
declarations
    :
        {
            //std::cout << "declarations -> \"\"" << std::endl;
        }
    | declaration declarations
        {
            //std::cout << "declarations -> declaration declarations" << std::endl;
        }
    ;
    
declaration
    : NATURAL IDENTIFIER SEMICOLON
        {
            insertSymbol(natural, *$2);
        }
    | BOOLEAN IDENTIFIER SEMICOLON
        {
            insertSymbol(boolean, *$2);
        }
    ;

body: TBEGIN statements END
    {
        //std::cout << "body -> TBEGIN statements END" << std::endl;
    }
;
    
statements
    : statement
        {
            //std::cout << "statements -> statement" << std::endl;
        }
    | statement statements
        {
            //std::cout << "statements -> statement statements" << std::endl;
        }
    ;

statement
    : skip
        {
            //std::cout << "statement -> skip" << std::endl;
        }
    | assignment
        {
            //std::cout << "statement -> assignment" << std::endl;
        }
    | write
        {
            //std::cout << "statement -> write" << std::endl;
        }
    | read
        {
            //std::cout << "statement -> read" << std::endl;
        }
    | while_loop
        {
            //std::cout << "statement -> while_loop" << std::endl;
        }
    | for_loop
        {
            //std::cout << "statement -> for_loop" << std::endl;
        }
    | conditional
        {
            //std::cout << "statement -> conditional" << std::endl;
        }
    ;

skip: SKIP SEMICOLON
    {
        //std::cout << "skip -> SKIP SEMICOLON" << std::endl;
    }
;
    
assignment: IDENTIFIER ASSIGN expr SEMICOLON
    {
        symbol_table::iterator it = symbols.find(*$1);
        if(it != symbols.end()) {
            assertType(":=", it->second.var_type, it->second.var_type, it->second.var_type, *$3);
        } else {
            undeclared(*$1);
        }
        delete $1;
        delete $3;
    }
;

write: WRITE LEFT_BRACKET expr RIGHT_BRACKET SEMICOLON
    {
        //std::cout << "write -> WRITE LEFT_BRACKET expr RIGHT_BRACKET SEMICOLON" << std::endl;
    }
;

read: READ LEFT_BRACKET IDENTIFIER RIGHT_BRACKET SEMICOLON
    {
        //std::cout << "read -> READ LEFT_BRACKET IDENTIFIER RIGHT_BRACKET SEMICOLON" << std::endl;
    }
;

while_loop: WHILE expr DO statements DONE
    {
        assertType("condition of while loop", boolean, *$2);
        delete $2;
    }
;

for_loop: FOR IDENTIFIER IN expr RANGE expr DO statements DONE
    {
        symbol_table::iterator it = symbols.find(*$2);
        if(it != symbols.end()) {
            assertType("for loop variable", natural, it->second.var_type);
            assertType("..", natural, natural, *$4, *$6);
        } else {
            undeclared(*$2);
        }
        delete $2;
        delete $4;
        delete $6;
    }
;
    
conditional
    : IF expr THEN statements ENDIF
        {
            assertType("condition of if statement", boolean, *$2);
        }
    | IF expr THEN statements ELSE statements ENDIF
        {
            assertType("condition of if statement", boolean, *$2);
        }
    ;

expr
    : TRUE
        {
            $$ = new type(boolean);
        }
    | FALSE
        {
            $$ = new type(boolean);
        }
    | NATURAL_LITERAL
        {
            $$ = new type(natural);
        }
    | IDENTIFIER
        {
            if(symbols.count(*$1) != 0) {
                $$ = new type(symbols[*$1].var_type);
            } else {
                undeclared(*$1);
            }
            delete $1;
        }
    | expr EQUALS expr
        {
            if(assertType("=", *$1, *$1, *$1, *$3)) {
                $$ = new type(boolean);
            }
            delete $1;
            delete $3;
        }
    | LEFT_BRACKET expr RIGHT_BRACKET
        {
            $$ = $2;
        }
    | NOT expr
        {
            assertType("not", boolean, *$2);
            $$ = new type(boolean);
            delete $2;
        }
    | expr AND expr
        {
            assertType("and", boolean, boolean, *$1, *$3);
            $$ = new type(boolean);
            delete $1;
            delete $3;
        }
    | expr OR expr
        {
            assertType("or", boolean, boolean, *$1, *$3);
            $$ = new type(boolean);
            delete $1;
            delete $3;
        }
    | expr LESS_THAN expr
        {
            assertType("<", natural, natural, *$1, *$3);
            $$ = new type(boolean);
            delete $1;
            delete $3;
        }
    | expr GREATER_THAN expr
        {
            assertType(">", natural, natural, *$1, *$3);
            $$ = new type(boolean);
            delete $1;
            delete $3;
        }
    | expr PLUS expr
        {
            assertType("+", natural, natural, *$1, *$3);
            $$ = new type(natural);
            delete $1;
            delete $3;
        }
    | expr MINUS expr
        {
            assertType("-", natural, natural, *$1, *$3);
            $$ = new type(natural);
            delete $1;
            delete $3;
        }
    | expr ASTERIKS expr
        {
            assertType("*", natural, natural, *$1, *$3);
            $$ = new type(natural);
            delete $1;
            delete $3;
        }
    | expr MOD expr
        {
            assertType("mod", natural, natural, *$1, *$3);
            $$ = new type(natural);
            delete $1;
            delete $3;
        }
    | expr DIV expr
        {
            assertType("div", natural, natural, *$1, *$3);
            $$ = new type(natural);
            delete $1;
            delete $3;
        }
    ;

