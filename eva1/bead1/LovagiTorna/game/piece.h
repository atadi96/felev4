#ifndef PIECE_H
#define PIECE_H

#include "enums.h"
#include "point.h"

namespace Game {

struct Piece
{
private:
    PieceType m_type;
    Point m_coord;
public:
    Piece() = default;
    Piece(PieceType type, Point coord) : m_type(type), m_coord(coord) {}
    PieceType type() const;
    Point coord() const;
    bool isWhite() const;
    bool isBlack() const;
    bool isPlayer(const Player& player) const;
    void updateCoord(const Point& toCoord);
    BoardColor color() const;
};

}
#endif // PIECE_H
