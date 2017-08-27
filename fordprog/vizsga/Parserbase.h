// Generated by Bisonc++ V4.09.02 on Wed, 07 Jun 2017 11:04:14 +0200

#ifndef ParserBase_h_included
#define ParserBase_h_included

#include <exception>
#include <vector>
#include <iostream>

// $insert preincludes
#include "semantics.h"

namespace // anonymous
{
    struct PI__;
}



class ParserBase
{
    public:
// $insert tokens

    // Symbolic tokens:
    enum Tokens__
    {
        PROGRAM = 257,
        TBEGIN,
        SKIP,
        END,
        NATURAL,
        BOOLEAN,
        TRUE,
        FALSE,
        NOT,
        IF,
        THEN,
        ELSE,
        ENDIF,
        WHILE,
        FOR,
        IN,
        RANGE,
        DO,
        DONE,
        READ,
        WRITE,
        LEFT_BRACKET,
        RIGHT_BRACKET,
        ASSIGN,
        SEMICOLON,
        COLON,
        GOTO,
        LABEL,
        IDENTIFIER,
        NATURAL_LITERAL,
        AND,
        OR,
        PRECNOT,
        EQUALS,
        LESS_THAN,
        GREATER_THAN,
        PLUS,
        MINUS,
        ASTERIKS,
        DIV,
        MOD,
    };

// $insert LTYPE
    struct LTYPE__
    {
        int timestamp;
        int first_line;
        int first_column;
        int last_line;
        int last_column;
        char *text;
    };
    
// $insert STYPE
union STYPE__
{
 std::string *text;
 expr_desc *expr;
 op_desc *op;
};


    private:
        int d_stackIdx__;
        std::vector<size_t>   d_stateStack__;
        std::vector<STYPE__>  d_valueStack__;
// $insert LTYPEstack
        std::vector<LTYPE__>      d_locationStack__;

    protected:
        enum Return__
        {
            PARSE_ACCEPT__ = 0,   // values used as parse()'s return values
            PARSE_ABORT__  = 1
        };
        enum ErrorRecovery__
        {
            DEFAULT_RECOVERY_MODE__,
            UNEXPECTED_TOKEN__,
        };
        bool        d_debug__;
        size_t      d_nErrors__;
        size_t      d_requiredTokens__;
        size_t      d_acceptedTokens__;
        int         d_token__;
        int         d_nextToken__;
        size_t      d_state__;
        STYPE__    *d_vsp__;
        STYPE__     d_val__;
        STYPE__     d_nextVal__;
// $insert LTYPEdata
        LTYPE__   d_loc__;
        LTYPE__  *d_lsp__;

        ParserBase();

        void ABORT() const;
        void ACCEPT() const;
        void ERROR() const;
        void clearin();
        bool debug() const;
        void pop__(size_t count = 1);
        void push__(size_t nextState);
        void popToken__();
        void pushToken__(int token);
        void reduce__(PI__ const &productionInfo);
        void errorVerbose__();
        size_t top__() const;

    public:
        void setDebug(bool mode);
}; 

inline bool ParserBase::debug() const
{
    return d_debug__;
}

inline void ParserBase::setDebug(bool mode)
{
    d_debug__ = mode;
}

inline void ParserBase::ABORT() const
{
    throw PARSE_ABORT__;
}

inline void ParserBase::ACCEPT() const
{
    throw PARSE_ACCEPT__;
}

inline void ParserBase::ERROR() const
{
    throw UNEXPECTED_TOKEN__;
}


// As a convenience, when including ParserBase.h its symbols are available as
// symbols in the class Parser, too.
#define Parser ParserBase


#endif

