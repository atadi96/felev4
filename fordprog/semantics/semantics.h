#include <iostream>
#include <string>
#include <map>
#include <sstream>

enum type {
    natural,
    boolean
};

struct var_data {
    int decl_row;
    type var_type;
    
    var_data() {}
    
    var_data(int decl_row, type var_type)
        : decl_row(decl_row), var_type(var_type) {}
};

