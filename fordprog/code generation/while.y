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
%token <text> NATURAL_LITERAL
%token <text> IDENTIFIER

%left AND OR
%left EQUALS
%left LESS_THAN GREATER_THAN
%left PLUS MINUS
%left ASTERIKS DIV MOD

%type <expr> expr;
%type <op> program;

%union
{
  std::string *text;
  expr_desc* expr;
  op_desc* op;
}

%%

start: program
    {
        std::string code =
          std::string(
            "extern be_egesz\n") + 
            "extern be_logikai\n" + 
            "extern ki_egesz\n" + 
            "extern ki_logikai\n" + 
            "global main\n" + 
            "section .bss\n";
        for(symbol_table::iterator it = symbols.begin(); it != symbols.end(); ++it) {
            code += "    " + it->first + ": resb " + it->second.size() + "\n";
        }
        code += std::string("section .text\n") +
                "main:\n";
        code += $1->code;
        delete $1;
        std::cout << code << std::endl;
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
            assertType(":=", it->second.var_type, it->second.var_type, it->second.var_type, $3->expr_type);
        } else {
            error_undeclared(*$1);
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
        assertType("condition of while loop", boolean, $2->expr_type);
        delete $2;
    }
;

for_loop: FOR IDENTIFIER IN expr RANGE expr DO statements DONE
    {
        symbol_table::iterator it = symbols.find(*$2);
        if(it != symbols.end()) {
            assertType("for loop variable", natural, it->second.var_type);
            assertType("..", natural, natural, $4->expr_type, $6->expr_type);
        } else {
            error_undeclared(*$2);
        }
        delete $2;
        delete $4;
        delete $6;
    }
;
    
conditional
    : IF expr THEN statements ENDIF
        {
            assertType("condition of if statement", boolean, $2->expr_type);
        }
    | IF expr THEN statements ELSE statements ENDIF
        {
            assertType("condition of if statement", boolean, $2->expr_type);
        }
    ;

expr
    : TRUE
        {
            $$ = new expr_desc(LINE, boolean, "    mov al, 1\n");
        }
    | FALSE
        {
            $$ = new expr_desc(LINE, boolean, "    mov al, 0\n");
        }
    | NATURAL_LITERAL
        {
            $$ = new expr_desc(LINE, natural, std::string("    mov eax, ") + *$1 + "\n");
        }
    | IDENTIFIER
        {
            if(symbols.count(*$1) != 0) {
                if(symbols[*$1].var_type == boolean) {
                    $$ = new expr_desc(LINE, symbols[*$1].var_type, std::string("    mov al, ") + *$1);
                }
                $$ = new expr_desc(LINE, symbols[*$1].var_type, std::string("    mov eax, ") + *$1 + "\n");
            } else {
                error_undeclared(*$1);
            }
            delete $1;
        }
    | expr EQUALS expr
        {
            if(assertType("=", $1->expr_type, $1->expr_type, $1->expr_type, $3->expr_type)) {
                $$ = new expr_desc(
                    LINE,
                    boolean, 
                    two_param_compare($1, $3, "sete")
                );
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
            assertType("not", boolean, $2->expr_type);
            $$ = new expr_desc(LINE, boolean, $2->code + "    xor al, 1\n");
            delete $2;
        }
    | expr AND expr
        {
            assertType("and", boolean, boolean, $1->expr_type, $3->expr_type);
            $$ = new expr_desc(
                LINE,
                boolean,
                two_param_expr($1, $3, "    and al, bl")
            );
            delete $1;
            delete $3;
        }
    | expr OR expr
        {
            assertType("or", boolean, boolean, $1->expr_type, $3->expr_type);
            $$ = new expr_desc(
                LINE,
                boolean,
                two_param_expr($1, $3, "    or al, bl")
            );
            delete $1;
            delete $3;
        }
    | expr LESS_THAN expr
        {
            assertType("<", natural, natural, $1->expr_type, $3->expr_type);
            $$ = new expr_desc(
                LINE,
                boolean, 
                two_param_compare($1, $3, "setb")
            );
            delete $1;
            delete $3;
        }
    | expr GREATER_THAN expr
        {
            assertType(">", natural, natural, $1->expr_type, $3->expr_type);
            $$ = new expr_desc(
                LINE,
                boolean, 
                two_param_compare($1, $3, "seta")
            );
            delete $1;
            delete $3;
        }
    | expr PLUS expr
        {
            assertType("+", natural, natural, $1->expr_type, $3->expr_type);
            $$ = new expr_desc(
                LINE,
                boolean,
                two_param_expr($1, $3, "    add eax, ebx")
            );
            delete $1;
            delete $3;
        }
    | expr MINUS expr
        {
            assertType("-", natural, natural, $1->expr_type, $3->expr_type);
            $$ = new expr_desc(
                LINE,
                boolean,
                two_param_expr($1, $3, "    sub eax, ebx")
            );
            delete $1;
            delete $3;
        }
    | expr ASTERIKS expr
        {
            assertType("*", natural, natural, $1->expr_type, $3->expr_type);
            $$ = new expr_desc(
                LINE,
                boolean,
                two_param_expr($1, $3, "    mul eax, ebx")
            );
            delete $1;
            delete $3;
        }
    | expr MOD expr
        {
            assertType("mod", natural, natural, $1->expr_type, $3->expr_type);
            $$ = new expr_desc(
                LINE,
                boolean,
                two_param_expr(
                    $1,
                    $3,
                    std::string("    xor edx, edx\n") + 
                    "    div eax, ebx\n" + 
                    "    mov eax, edx"
                )
            );
            delete $1;
            delete $3;
        }
    | expr DIV expr
        {
            assertType("div", natural, natural, $1->expr_type, $3->expr_type);
            $$ = new expr_desc(
                LINE,
                boolean,
                two_param_expr(
                    $1,
                    $3,
                    std::string("    xor edx, edx\n") + 
                    "    div eax, ebx"
                )
            );
            delete $1;
            delete $3;
        }
    ;

