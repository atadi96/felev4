#ifndef GAME_H
#define GAME_H

#include "point.h"
#include <vector>
#include <QVector>

class Game
{
public:
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
    };
    struct Field
    {
        Field() = default;
        Field(int color, int piece) noexcept : color(color), piece(piece) { }
        int color = BoardColor::Grey;
        int piece = PieceType::None;
    };
    struct Piece
    {
        int type;
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

#endif // GAME_H
