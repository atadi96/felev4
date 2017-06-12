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
%token COLON
%token GOTO
%token <text> LABEL
%token <text> IDENTIFIER
%token <text> NATURAL_LITERAL

%left AND OR
%right PRECNOT
%left EQUALS
%left LESS_THAN GREATER_THAN
%left PLUS MINUS
%left ASTERIKS DIV MOD

%type <expr> expr;
%type <text> body, statements, program;
%type <op> statement, skip, assignment, write, read, while_loop, for_loop, conditional, label_decl, goto_stmt;

%union
{
  std::string *text;
  expr_desc *expr;
  op_desc *op;
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
        code += *$1;
        std::cout << code << std::endl;
        delete $1;
    }
;
    
program: header declarations body
    {
        for(label_table::iterator it = labels.begin(); it != labels.end(); ++it) {
            label_data label = it->second;
            if(!label.declared) {
                std::stringstream ss;
                ss << "Use of undeclared label \"" << label.name << "\" "
                   << " at line " << label.used_row << "\n";
                error(ss.str().c_str());
            }
        }
        $$ = $3;
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
        $$ = $2;
    }
;
    
statements
    : statement
        {
            $$ = new std::string($1->code);
            delete $1;
        }
    | statement statements
        {
            $$ = new std::string ($1->code + *$2);
            delete $1;
            delete $2;
        }
    ;

statement
    : skip
        {
            $$ = $1;
        }
    | assignment
        {
            $$ = $1;
        }
    | write
        {
            $$ = $1;
        }
    | read
        {
            $$ = $1;
        }
    | while_loop
        {
            $$ = $1;
        }
    | for_loop
        {
            $$ = $1;
        }
    | conditional
        {
            $$ = $1;
        }
    | label_decl
        {
            $$ = $1;
        }
    | goto_stmt
        {
            $$ = $1;
        }
    ;

skip: SKIP SEMICOLON
    {
        $$ = new op_desc(LINE, "    nop\n");
    }
;
    
assignment: IDENTIFIER ASSIGN expr SEMICOLON
    {
        symbol_table::iterator it = symbols.find(*$1);
        if(it != symbols.end()) {
            assertType(":=", it->second.var_type, it->second.var_type, it->second.var_type, $3->expr_type);
            $$ = new op_desc(LINE, $3->code + "    mov [" + *$1 +"], " + registers::a(size_of($3->expr_type)) + "\n");
        } else {
            error_undeclared(*$1);
        }
        delete $1;
        delete $3;
    }
;

write: WRITE LEFT_BRACKET expr RIGHT_BRACKET SEMICOLON
    {
        $$ = new op_desc(
            LINE,
            $3->code +
            "    push eax\n" +
            "    call " + ($3->expr_type == natural ? "ki_egesz" : "ki_logikai") + "\n" +
            "    add esp, 4\n"
        );
        delete $3;
    }
;

read: READ LEFT_BRACKET IDENTIFIER RIGHT_BRACKET SEMICOLON
    {
        symbol_table::iterator it = symbols.find(*$3);
        if(it != symbols.end()) {
            $$ = new op_desc(
                LINE,
                std::string("    call ") + (it->second.var_type == natural ? "be_egesz" : "be_logikai") + "\n" +
                "    mov [" + *$3 + "], " + registers::a(size_of(it->second.var_type)) + "\n"
            );
        } else {
            error_undeclared(*$3);
        }
        delete $3;
    }
;

while_loop: WHILE expr DO statements DONE
    {
        assertType("condition of while loop", boolean, $2->expr_type);
        std::string label_postfix = label::get_new();
        std::string start_label = std::string("while_start_") + label_postfix;
        std::string end_label = std::string("while_end_") + label_postfix;
        $$ = new op_desc(
            LINE,
            start_label + ":\n" +
            $2->code +
            "    cmp al, 1\n" +
            "    jne near " + end_label + "\n" +
            *$4 +
            "    jmp near " + start_label + "\n" +
            end_label + ":\n"
        );
        delete $2;
        delete $4;
    }
;

for_loop: FOR IDENTIFIER IN expr RANGE expr DO statements DONE
    {
        symbol_table::iterator it = symbols.find(*$2);
        if(it != symbols.end()) {
            assertType("for loop variable", natural, it->second.var_type);
            assertType("..", natural, natural, $4->expr_type, $6->expr_type);
            
            std::string label_postfix = label::get_new();
            std::string start_label = std::string("for_start_") + label_postfix;
            std::string end_label = std::string("for_end_") + label_postfix;
            std::string a = registers::a(size_of($4->expr_type));
            std::string d = registers::d(size_of($4->expr_type));
            $$ = new op_desc(
                LINE,
                std::string(";for loop from here\n") +
                $4->code + 
                "    mov [" + *$2 + "], " + a + "\n" +
                $6->code +
                "    push eax\n" +
                start_label + ":\n" +
                "    pop edx\n" +
                "    mov " + a + ", [" + *$2 + "]\n" +
                "    cmp " + a + ", " + d + "\n" +
                "    ja " + end_label + "\n" +
                "    push edx\n" +
                *$8 + 
                "    inc " + asm_size($4->expr_type) + " [" + *$2 + "]\n" +
                "    jmp " + start_label + "\n" +
                end_label + ":\n"
            );
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
            std::string iflabel("if_then_");
            iflabel += label::get_new();
            $$ = new op_desc(
                LINE,
                $2->code + 
                "    cmp al, 1\n" +
                "    jne near " + iflabel + "\n" +
                *$4 + 
                iflabel + ":\n"
            );
            delete $2;
            delete $4;
        }
    | IF expr THEN statements ELSE statements ENDIF
        {
            assertType("condition of if statement", boolean, $2->expr_type);
            std::string label_postfix = label::get_new();
            std::string else_label = std::string("if_else_") + label_postfix;
            std::string end_label = std::string("if_end_") + label_postfix;
            $$ = new op_desc(
                LINE,
                std::string("    ;if-then-else\n") + 
                $2->code + 
                "    cmp al, 1\n" +
                "    jne near " + else_label + "\n" +
                *$4 + 
                "    jmp " + end_label + "\n" +
                else_label + ":\n" +
                *$6 + 
                end_label + ":\n"
            );
            delete $2;
            delete $4;
            delete $6;
        }
    ;
    
label_decl: LABEL COLON
    {
        declare_label(LINE, *$1);
        $$ = new op_desc(
            LINE,
            std::string("_while_label_") +
            *$1 + ":\n"
        );
    }
;

goto_stmt: GOTO LABEL SEMICOLON
    {
        use_label(LINE, *$2);
        $$ = new op_desc(
            LINE,
            std::string("    jmp near _while_label_") +
            *$2 + "\n"
        );
        delete $2;
    }
;

expr
    : TRUE
        {
            $$ = new expr_desc(LINE, boolean, "    mov al, byte 1\n");
        }
    | FALSE
        {
            $$ = new expr_desc(LINE, boolean, "    mov al, byte 0\n");
        }
    | NATURAL_LITERAL
        {
            $$ = new expr_desc(LINE, natural, std::string("    mov eax, ") + *$1 + "\n");
            delete $1;
        }
    | IDENTIFIER
        {
            if(symbols.count(*$1) != 0) {
                $$ = new expr_desc(LINE, symbols[*$1].var_type, std::string("    mov ") + registers::a(size_of(symbols[*$1].var_type)) + ", [" + *$1 + "]\n");
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
    | NOT expr %prec PRECNOT
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
                two_param_expr($1, $3, "and al, bl")
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
                two_param_expr($1, $3, "or al, bl")
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
                natural,
                two_param_expr($1, $3, "add eax, ebx")
            );
            delete $1;
            delete $3;
        }
    | expr MINUS expr
        {
            assertType("-", natural, natural, $1->expr_type, $3->expr_type);
            $$ = new expr_desc(
                LINE,
                natural,
                two_param_expr($1, $3, "sub eax, ebx")
            );
            delete $1;
            delete $3;
        }
    | expr ASTERIKS expr
        {
            assertType("*", natural, natural, $1->expr_type, $3->expr_type);
            $$ = new expr_desc(
                LINE,
                natural,
                two_param_expr($1, $3, "mul ebx")
            );
            delete $1;
            delete $3;
        }
    | expr MOD expr
        {
            assertType("mod", natural, natural, $1->expr_type, $3->expr_type);
            $$ = new expr_desc(
                LINE,
                natural,
                two_param_expr(
                    $1,
                    $3,
                    std::string("xor edx, edx\n") + 
                    "    div ebx\n" + 
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
                natural,
                two_param_expr(
                    $1,
                    $3,
                    std::string("xor edx, edx\n") + 
                    "    div ebx"
                )
            );
            delete $1;
            delete $3;
        }
    ;

