#include "qboardbutton.h"

const int BoardColor::Grey  = 0;
const int BoardColor::White = 1;
const int BoardColor::Black = 2;

const int PieceType::WhiteLeft = 0;
const int PieceType::WhiteRight = 1;
const int PieceType::BlackLeft = 2;
const int PieceType::BlackRight = 3;

void QBoardButton::setColor(int color) {
    this->m_color = color;
}

int QBoardButton::color() const {
    return this->m_color;
}


void QBoardButton::setPiece(int piece) {
    this->m_piece = piece;
}

int QBoardButton::piece() const {
    return this->m_piece;
}

