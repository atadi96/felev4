#include <iostream>
#include <fstream>
#include <FlexLexer.h>

int main(int argc, const char* argv[]) {
    if(argc != 2) {
        std::cerr << "Usage: lexer filename" << std::endl;
        return 1;
    } else {
        std::ifstream fs(argv[1]);
        if(fs.fail()) {
            std::cerr << "Could not open specified file." << std::endl;
            return 1;
        } else {
            yyFlexLexer fl(&fs, &std::cout);
            fl.yylex();
            return 0;
        }
    }
    return 1;
}