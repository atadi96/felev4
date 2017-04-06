%option noyywrap c++ yylineno

%{
#include <iostream>
#include "Parserbase.h"

using namespace std;

%}

DIGIT   [0-9]
IDENTIFIER_START [a-zA-Z_]
IDENT {IDENTIFIER_START}({IDENTIFIER_START}|{DIGIT})*
WS  [ \t\n]

%%

program     return Parser::PROGRAM;
begin       return Parser::TBEGIN;
skip        return Parser::SKIP;
end         return Parser::END;
natural     return Parser::NATURAL;
boolean     return Parser::BOOLEAN;
true        return Parser::TRUE;
false       return Parser::FALSE;
not         return Parser::NOT;
if          return Parser::IF;
then        return Parser::THEN;
else        return Parser::ELSE;
endif       return Parser::ENDIF;
while       return Parser::WHILE;
for         return Parser::FOR;
in          return Parser::IN;
".."        return Parser::RANGE;
do          return Parser::DO;
done        return Parser::DONE;
read        return Parser::READ;
write       return Parser::WRITE;

and         return Parser::AND;
or          return Parser::OR;
=           return Parser::EQUALS;
"<"         return Parser::LESS_THAN;
>           return Parser::GREATER_THAN;
"+"         return Parser::PLUS;
-           return Parser::MINUS;
"*"         return Parser::ASTERIKS;
div         return Parser::DIV;
mod         return Parser::MOD;

"("         return Parser::LEFT_BRACKET;
")"         return Parser::RIGHT_BRACKET;
:=          return Parser::ASSIGN;
;           return Parser::SEMICOLON;

{DIGIT}+    return Parser::NATURAL_LITERAL;
{IDENT}     return Parser::IDENTIFIER;

{WS}+       // feher szokozok - semmi teendo
#.*         //komment a sor vegeig - nincs teendo

.           {
                std::cerr << "Line " << lineno() << ": Parse error: Unexpected character '" << YYText() << "'" << std::endl;
                exit(1);
            }

%%
