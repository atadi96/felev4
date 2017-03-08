#include "qchessboardlayout.h"
#include <QStyle>

QChessBoardLayout::QChessBoardLayout(int gameSize, QWidget* parent = 0) : QGridLayout(parent), game(gameSize) {
    this->setSpacing(0);
    int fieldNum = gameSize * gameSize;
    connect(&game, SIGNAL(redraw()), this, SLOT(redraw()));
    for(int i = 0; i < fieldNum; ++i) {
        QBoardButton* btn = new QBoardButton();
        btn->setHighlighted(false);
        btn->setSizePolicy(QSizePolicy::Expanding, QSizePolicy::Expanding);
        this->addWidget(btn, i / gameSize, i % gameSize);
        connect(btn, SIGNAL(clicked()), this, SLOT(fieldClick()));
        btnVector.push_back(btn);
    }
    redraw();
}

QChessBoardLayout::~QChessBoardLayout() {
    /*for(auto it = btnVector.begin(); it != btnVector.end(); ++it) {
        delete *it;
    }*/
}

void QChessBoardLayout::redraw() {
    int fieldNum = game.size() * game.size();
    for(int i = 0; i < fieldNum; ++i) {
        QBoardButton* btn = btnVector[i];
        const Game::Field &f = game.getField(i / game.size(), i % game.size());
        btn->setColor(static_cast<int>(f.color));
        btn->setPiece(static_cast<int>(f.piece));
        btn->setHighlighted(f.highlighted);
        btn->style()->unpolish(btn);
        btn->style()->polish(btn);
    }
}

void QChessBoardLayout::fieldClick() {
    int index = this->indexOf(dynamic_cast<QWidget*>(sender()));
    game.act(index / game.size(), index % game.size());
}
