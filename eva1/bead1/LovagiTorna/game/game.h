#ifndef GAME_H
#define GAME_H

#include "point.h"
#include <vector>
#include <QVector>

namespace Game
{

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

class Game
{
public:/*
    struct BoardColor
    {
        static const int Grey;
        static const int White;
        static const int Black;
    };
    struct PieceType
    {
        static const int None;
        static const int WhiteLeft;
        static const int WhiteRight;
        static const int BlackLeft;
        static const int BlackRight;
    };*/
    struct Field
    {
        Field() = default;
        Field(BoardColor color, PieceType piece) noexcept : color(color), piece(piece) { }
        BoardColor color = BoardColor::Grey;
        PieceType piece = PieceType::None;
    };
    struct Piece
    {
        PieceType type;
        Point coord;
        bool isWhite() const;
        bool isBlack() const;
    };

private:
    typedef QVector<QVector<Field>> Map;
    int m_size;
    Point highBound;
    Map map;
    void movePiece(Piece& piece, const Point& toCoord);

public:
    Game(int size) : m_size(size), highBound(size, size), map(size, {QVector<Field>(size, Field()) }) {}
    void act(int x, int y);
    const Field& getField(const Point& point) const;
    const Field& getField(int x, int y) const;
    const QVector<Point> getHighlightedFields() const;
};

}
#endif // GAME_H
