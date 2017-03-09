#ifndef ENUMS_H
#define ENUMS_H
namespace Game {

enum class Player
{
    None,
    White,
    Black
};

enum class BoardColor
{
    Grey = 0,
    White = 1,
    Black = 2
};

enum class PieceType
{
    None = 0,
    WhiteLeft = 1,
    WhiteRight = 2,
    BlackLeft = 3,
    BlackRight = 4
};

}

#endif // ENUMS_H
