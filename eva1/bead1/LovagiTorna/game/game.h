#ifndef GAME_H
#define GAME_H

#include <vector>
#include <QVector>
#include <QObject>
#include "point.h"
#include "piece.h"
#include "enums.h"

namespace Game
{

struct Field
{
    Field() = default;
    Field(BoardColor color, PieceType piece, bool highlighted) noexcept : color(color), piece(piece), highlighted(highlighted) { }
    BoardColor color = BoardColor::Grey;
    PieceType piece = PieceType::None;
    bool highlighted = false;
};

class Game : public QObject
{
    Q_OBJECT

private:
    typedef QVector<QVector<Field>> Map;
    int m_size;
    Point highBound;
    Map map;
    QVector<Point> m_highlighted_fields;
    Player onTurn;
    Piece* m_selectedPiece;
    QVector<Piece> pieces;
public:
    Game(int size);
    void act(int x, int y);
    const Field& getField(const Point& point) const;
    const Field& getField(int x, int y) const;
    const QVector<Point> highlightedFields() const;
    int size() const;

private:
    void movePiece(Piece& piece, const Point& toCoord);
    void setHighlightedFields();
    void checkWin(const Point& center);
    void switchPlayer();
    bool collidesWithPiece(const Point& point) const;
    Field& field(const Point& point);
    Field& field(int x, int y);

signals:
    void redraw();
    void gameFinished(Player winner);

};

}
#endif // GAME_H
