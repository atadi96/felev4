%baseclass-preinclude "semantics.h"
%lsp-needed

%token NATURAL;
%token BOOLEAN;
%token TRUE;
%token FALSE;
%token NUMBER;
%token <szoveg> IDENT;
%token ASSIGN;

%type <var_type> expr;

%union
{
  std::string *szoveg;
  type* var_type;
}

%%

start:
    declarations assignments
;

declarations:
    // ures
|
    declaration declarations
;

declaration:
    NATURAL IDENT
	{
		if( szimbolumtabla.count(*$2) > 0 ) {
			std::stringstream ss;
			ss << "Ujradeklaralt valtozo: " << *$2 << ".\n"
			<< "Korabbi deklaracio sora: " << szimbolumtabla[*$2].decl_row << std::endl;
			error( ss.str().c_str() );
		} else {
			szimbolumtabla[*$2] = var_data( d_loc__.first_line, natural );
		}
		delete $2;
	}
|
    BOOLEAN IDENT
	{
	    if( szimbolumtabla.count(*$2) > 0 ) {
			std::stringstream ss;
			ss << "Ujradeklaralt valtozo: " << *$2 << ".\n"
			<< "\tKorabbi deklaracio sora: " << szimbolumtabla[*$2].decl_row << std::endl;
			error( ss.str().c_str() );
		} else {
			szimbolumtabla[*$2] = var_data( d_loc__.first_line, boolean );
		}
		delete $2;
	}
;

assignments:
    // ures
|
    assignment assignments
;

assignment:
    IDENT ASSIGN expr
	{
		if( szimbolumtabla.count(*$1) == 0 ) {
			std::stringstream ss;
			ss << "Nem deklaralt : " << *$1 << std::endl;
			error( ss.str().c_str() );
		}
		if(szimbolumtabla[*$1].var_type != *$3) {
			std::stringstream ss;
			ss << "Tipushibas ertekadas.\n"
				<< "\tValtozo tipusa: " << typeToString(szimbolumtabla[*$1].var_type)
				<< "\n\tKifejezes tipusa: " << typeToString(*$3) << std::endl;
			error( ss.str().c_str() );
		}
		delete $1;
		delete $3;
	}
;

expr:
    IDENT
	{
		if( szimbolumtabla.count(*$1) == 0 ) {
			std::stringstream ss;
			ss << "Nem deklaralt : " << *$1 << std::endl;
			error( ss.str().c_str() );
		} else {
			$$ = new type(szimbolumtabla[*$1].var_type);
		}
		delete $1;
	}
|
    NUMBER
	{
		$$ = new type(natural);
	}
|
    TRUE
	{
		$$ = new type(boolean);
	}
|
    FALSE
	{
		$$ = new type(boolean);
	}
;
