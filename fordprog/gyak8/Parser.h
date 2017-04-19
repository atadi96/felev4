// Generated by Bisonc++ V4.09.02 on Mon, 02 Nov 2015 16:47:26 +0100

#ifndef Parser_h_included
#define Parser_h_included

// $insert baseclass
#include "Parserbase.h"
#include <FlexLexer.h>

#undef Parser
class Parser: public ParserBase
{
        
    public:
        Parser(std::istream& inFile) : lexer( &inFile, &std::cerr ) {}
        int parse();

    private:
        yyFlexLexer lexer;
		std::map<std::string,var_data> szimbolumtabla;
		
        void error(char const *msg);    // called on (syntax) errors
        int lex();                      // returns the next token from the
                                        // lexical scanner. 
        void print();                   // use, e.g., d_token, d_loc

    // support functions for parse():
        void executeAction(int ruleNr);
        void errorRecovery();
        int lookup(bool recovery);
        void nextToken();
        void print__();
        void exceptionHandler__(std::exception const &exc);
		
		std::string typeToString(type var_type);
};


#endif
