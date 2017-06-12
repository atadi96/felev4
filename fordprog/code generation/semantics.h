#include <iostream>
#include <string>
#include <map>
#include <sstream>

#ifndef _semantics_h
#define _semantics_h

enum type {
    natural,
    boolean
};


struct expr_desc
{
    int decl_row;
    type expr_type;
    std::string code;
    expr_desc(int row, type t, std::string c)
        : decl_row(row), expr_type(t), code(c) {}
};

struct op_desc
{
    int decl_row;
    std::string code;
    op_desc(int row, std::string c)
        : decl_row(row), code(c) {} 
};

struct var_data {
    int decl_row;
    type var_type;
    
    var_data() {}
    
    var_data(int decl_row, type var_type)
        : decl_row(decl_row), var_type(var_type) {}
        
    std::string size() const {
        if(var_type == natural) {
            return "4";
        }
        if(var_type == boolean) {
            return "1";
        }
        throw "Unsupported data type";
    }
};

#endif