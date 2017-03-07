#include "qchessboardlayout.h"

QChessBoardLayout::QChessBoardLayout(int gameSize, QWidget* parent = 0) : QGridLayout(parent), game(gameSize) {
    this->setSpacing(0);
    int fieldNum = gameSize * gameSize;
    for(int i = 0; i < fieldNum; ++i) {
        QBoardButton* btn = new QBoardButton();
        this->addWidget(btn, i / gameSize, i % gameSize);
        btnVector.push_back(btn);
    }
}

QChessBoardLayout::~QChessBoardLayout() {
    for(auto it = btnVector.begin(); it != btnVector.end(); ++it) {
        delete *it;
    }
}

void QChessBoardLayout::redraw() {
    int fieldNum = game.size() * game.size();
    for(int i = 0; i < fieldNum; ++i) {
        auto btn = btnVector[i];
        const Game::Field &f = game.getField(i / game.size(), i % game.size());
        btn->setColor(static_cast<int>(f.color));
        btn->setPiece(static_cast<int>(f.piece));
    }
}
