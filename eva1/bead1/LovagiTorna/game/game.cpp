#include "game.h"
#include <algorithm>

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
    setHighlightedFields();
}

const Field& Game::getField(const Point& point) const {
    return getField(point.x(), point.y());
}
const Field& Game::getField(int x, int y) const {
    return map.at(x).at(y);
}

int Game::size() const {
    return m_size;
}

Field& Game::field(const Point& point){
    return field(point.x(), point.y());
}
Field& Game::field(int x, int y) {
    return map[x][y];
}

const QVector<Point> Game::highlightedFields() const {
    return m_highlighted_fields;
}
void Game::act(int x, int y) {
    Point p(x,y);
    if(m_highlighted_fields.end() != std::find(m_highlighted_fields.begin(), m_highlighted_fields.end(), p) ) {
        if(m_selectedPiece == nullptr) {
            m_selectedPiece = std::find_if(pieces.begin(), pieces.end(), [&p](const Piece& piece) {return piece.coord() == p;});
        } else {
            if(m_selectedPiece->coord() == p) {
                m_selectedPiece = nullptr;
            } else {
                movePiece(*m_selectedPiece, p);
                m_selectedPiece = nullptr;
                checkWin(p);
                switchPlayer();
            }
        }
    } else {
        m_selectedPiece = nullptr;
    }
    setHighlightedFields();
    emit redraw();
}
/*private*/

void Game::movePiece(Piece& piece, const Point& toCoord) {
    field(piece.coord()).piece = PieceType::None;
    piece.updateCoord(toCoord);
    field(toCoord).piece = piece.type();
    field(toCoord).color = piece.color();
}

void Game::setHighlightedFields() {
    m_highlighted_fields.clear();
    if(m_selectedPiece == nullptr) {
        for(auto it = pieces.begin(); it != pieces.end(); ++it) {
            if(it->isPlayer(this->onTurn)) {
                m_highlighted_fields.push_back(it->coord());
            }
        }
    } else {
        Point center = m_selectedPiece->coord();
        for(int sx = -1; sx == -1 || sx == 1; sx += 2) {
            for(int sy = -1; sy == -1 || sy == 1; sy += 2) {
                for(int x = 1; x <= 2; ++x) {
                    for(int y = 1; y <= 2; ++y) {
                        Point p(sx * x, sy * y);
                        p += center;
                        if(x != y && p.inRectangle(Point::zero, highBound) && !collidesWithPiece(p)) {
                            m_highlighted_fields.push_back(p);
                        }
                    }
                }
            }
        }
        m_highlighted_fields.push_back(center);
    }
    for(int x = 0; x < m_size; ++x) {
        for(int y = 0; y < m_size; ++y) {
            field(x, y).highlighted = false;
        }
    }
    for(auto it = m_highlighted_fields.begin(); it != m_highlighted_fields.end(); ++it) {
        field(*it).highlighted = true;
    }
}

void Game::checkWin(const Point& center){

}

bool Game::collidesWithPiece(const Point& point) const {
    auto it = std::find_if(pieces.begin(), pieces.end(), [&point](Piece p) {return p.coord() == point;});
    return (it != pieces.end());
}

void Game::switchPlayer() {
    if(onTurn == Player::Black) {
        onTurn = Player::White;
    } else if(onTurn == Player::White){
        onTurn = Player::Black;
    }
}

}
