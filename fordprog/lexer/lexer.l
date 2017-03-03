%option noyywrap c++ yylineno

%{
#include <iostream>
#include <cstdlib>
#include <string>

using namespace std;

/*
void fKeyword(string word) {
    std::cout << "keyword: " << word << std::endl;
}

void fError(int line, string word) {
    std::cerr << "Line " << line << "Parse error: Unexpected character '" << word << "'" << std::endl;
    exit(1);
} */

%}

DIGIT   [0-9]
IDENTIFIER_START [a-zA-Z_]
IDENT {IDENTIFIER_START}({IDENTIFIER_START}|{DIGIT})*
WS  [ \t\n]

%%

program     std::cout << "keyword: " << YYText() << std::endl;
begin       std::cout << "keyword: " << YYText() << std::endl;
end         std::cout << "keyword: " << YYText() << std::endl;
natural     std::cout << "keyword: " << YYText() << std::endl;
boolean     std::cout << "keyword: " << YYText() << std::endl;
true        std::cout << "literal: boolean: " << YYText() << std::endl;
false       std::cout << "literal: boolean: " << YYText() << std::endl;
div         std::cout << "operator: " << YYText() << std::endl;
mod         std::cout << "operator: " << YYText() << std::endl;
and         std::cout << "operator: " << YYText() << std::endl;
or          std::cout << "operator: " << YYText() << std::endl;
not         std::cout << "operator: " << YYText() << std::endl;
skip        std::cout << "keyword: " << YYText() << std::endl;
if          std::cout << "keyword: " << YYText() << std::endl;
then        std::cout << "keyword: " << YYText() << std::endl;
else        std::cout << "keyword: " << YYText() << std::endl;
endif       std::cout << "keyword: " << YYText() << std::endl;
while       std::cout << "keyword: " << YYText() << std::endl;
for         std::cout << "keyword: " << YYText() << std::endl;
in          std::cout << "keyword: " << YYText() << std::endl;
do          std::cout << "keyword: " << YYText() << std::endl;
done        std::cout << "keyword: " << YYText() << std::endl;
read        std::cout << "keyword: " << YYText() << std::endl;
write       std::cout << "keyword: " << YYText() << std::endl;

{DIGIT}+    std::cout << "literal: number: " << YYText() << std::endl;
{IDENT}     std::cout << "identifier: " << YYText() << std::endl; 

"("         std::cout << "bracket: " << YYText() << std::endl;
")"         std::cout << "bracket: " << YYText() << std::endl;
:=           std::cout << "operator: " << YYText() << std::endl;
-           std::cout << "operator: " << YYText() << std::endl;
"+"           std::cout << "operator: " << YYText() << std::endl;
"*"         std::cout << "operator: " << YYText() << std::endl;
".."           std::cout << "operator: " << YYText() << std::endl;
"<"           std::cout << "operator: " << YYText() << std::endl;
>           std::cout << "operator: " << YYText() << std::endl;
=           std::cout << "operator: " << YYText() << std::endl;
;           std::cout << "separator: " << YYText() << std::endl;

{WS}+       // feher szokozok - semmi teendo
#.*         //komment a sor vegeig - nincs teendo

.           {
                std::cerr << "Line " << lineno() << ": Parse error: Unexpected character '" << YYText() << "'" << std::endl;
                exit(1);
            }

%%
