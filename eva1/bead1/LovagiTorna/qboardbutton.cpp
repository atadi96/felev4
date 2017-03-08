#include "qboardbutton.h"

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

void QBoardButton::setHighlighted(bool hl) {
    m_highlighted = hl;
}

bool QBoardButton::highlighted() const {
    return m_highlighted;
}

