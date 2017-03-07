#include "widget.h"
#include "ui_widget.h"

Widget::Widget(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::Widget)
{
    gl = new QGridLayout(this);
    gl->setSpacing(0);
    this->setLayout(gl);
    Game::Game game(8);
    for(int i = 0; i < 64; ++i) {
        QBoardButton* btn = new QBoardButton();
        //btn->setText((i%2==0)!=((i/8)%2==0)?QString("FEKETE"):QString("feher"));
        //btn->setColor((i%2==0)!=((i/8)%2==0) ? static_cast<int>(Game::BoardColor::Black) : static_cast<int>(Game::BoardColor::White));
        //btn->setPiece(static_cast<int>(Game::PieceType::BlackLeft));
        const Game::Field &f = game.getField(i/8, i%8);
        btn->setColor(static_cast<int>(f.color));
        btn->setPiece(static_cast<int>(f.piece));
        gl->addWidget(btn, i/8, i%8);
        btnVector.push_back(btn);
    }
    ui->setupUi(this);
}

Widget::~Widget()
{
    for(QVector<QBoardButton*>::iterator it = btnVector.begin(); it != btnVector.end(); ++it) {
        delete *it;
    }
    delete ui;
}
