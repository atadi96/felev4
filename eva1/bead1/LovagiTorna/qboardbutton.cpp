#include "qboardbutton.h"

const int BoardColor::Grey  = 0;
const int BoardColor::White = 1;
const int BoardColor::Black = 2;

void QBoardButton::setColor(int color) {
    this->m_color = color;
}

int QBoardButton::color() const {
    return this->m_color;
}


void QBoardButton::setPiece(Piece piece) {
    this->m_piece = piece;
}

QBoardButton::Piece QBoardButton::piece() const {
    return this->m_piece;
}

