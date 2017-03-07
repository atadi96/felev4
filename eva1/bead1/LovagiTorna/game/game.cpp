#include "game.h"

namespace Game {

/*public*/

Game::Game(int size)
    : m_size(size)
    , highBound(size - 1, size - 1)
    , map(size, {QVector<Field>(size, Field()) })
    , onTurn(Player::White)
    , m_selectedPiece(nullptr)
{
    pieces.push_back(Piece(PieceType::WhiteRight, Point(0,0)));
    pieces.push_back(Piece(PieceType::WhiteLeft, highBound));
    pieces.push_back(Piece(PieceType::BlackLeft, Point(0,highBound.y())));
    pieces.push_back(Piece(PieceType::BlackRight, Point(highBound.x(),0)));
    for(auto it = pieces.begin(); it != pieces.end(); ++it) {
        movePiece(*it, it->coord());
    }
}

const Field& Game::getField(const Point& point) const {
    return getField(point.x(), point.y());
}
const Field& Game::getField(int x, int y) const {
    return map.at(x).at(y);
}

Field& Game::field(const Point& point){
    return field(point.x(), point.y());
}
Field& Game::field(int x, int y) {
    return map[x][y];
}

const QVector<Point> Game::highlightedFields() const {

}
void Game::act(int x, int y) {

}

/*private*/

void Game::movePiece(Piece& piece, const Point& toCoord) {
    field(piece.coord()).piece = PieceType::None;
    piece.updateCoord(toCoord);
    field(toCoord).piece = piece.type();
    field(toCoord).color = piece.color();
}

void Game::setHighlightedFields(const Point& center) { //WIP
    m_highlighted_fields.clear();
    for(int sx = -1; sx == -1 || sx == 1; sx += 2) {
        for(int sy = -1; sy == -1 || sy == 1; sy += 2) {
            for(int x = 2; x <= 3; ++x) {
                for(int y = 2; y <= 3; ++y) {
                    Point p(sx * x, sy * y);
                    p += center;
                    if(p.inRectangle(Point::zero, highBound) && !collidesWithPiece(p)) {
                        m_highlighted_fields.push_back(p);
                    }
                }
            }
        }
    }
}

void Game::checkWin(const Point& center){

}

bool Game::collidesWithPiece(const Point& point) const {
    //auto it =
}

}
