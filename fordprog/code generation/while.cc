#include <iostream>
#include <fstream>
#include <string>

#include "Parser.h"
#include <FlexLexer.h>

bool open_input(std::ifstream& in, int argc, char* argv[]);

int main(int argc, char* argv[]) {
    std::ifstream in;
    if(open_input(in, argc, argv)) {
        Parser parser(in);
        parser.parse();
        return 0;
    } else {
        return 1;
    }
}

bool open_input(std::ifstream& in, int argc, char* argv[]) {
    if(argc != 2) {
        std::cout << "Usage: while sourcefile" << std::endl;
        return false;
    } else {
        in.open(argv[1]);
        if(in) {
            return true;
        } else {
            std::cerr << "Couldn't open file \"" << argv[1] << std::endl;
            return false;
        }
    }
}
