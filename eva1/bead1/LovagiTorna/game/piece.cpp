#include "piece.h"

namespace Game {

PieceType Piece::type() const {
    return m_type;
}
Point Piece::coord() const {
    return m_coord;
}

bool Piece::isWhite() const {
    switch(m_type) {
    case PieceType::WhiteLeft:
    case PieceType::WhiteRight:
        return true;
    default:
        return false;
    }
}
bool Piece::isBlack() const {
    switch(m_type) {
    case PieceType::BlackLeft:
    case PieceType::BlackRight:
        return true;
    default:
        return false;
    }
}
bool Piece::isPlayer(const Player& player) const {
    switch(player) {
    case Player::Black:
        return isBlack();
    case Player::White:
        return isWhite();
    default:
        return false;
    }
}
void Piece::updateCoord(const Point& toCoord) {
    Point moveVector = toCoord - m_coord;
    if(moveVector.y() > 0) {
        if(isWhite()) {
            m_type = PieceType::WhiteRight;
        } else if(isBlack()) {
            m_type = PieceType::BlackRight;
        }
    } else if(moveVector.y() < 0) {
        if(isWhite()) {
            m_type = PieceType::WhiteLeft;
        } else if(isBlack()) {
            m_type = PieceType::BlackLeft;
        }
    }
    m_coord = toCoord;
}

BoardColor Piece::color() const {
    if(isWhite()) {
        return BoardColor::White;
    } else if(isBlack()) {
        return BoardColor::Black;
    } else {
        return BoardColor::Grey;
    }
}

}
