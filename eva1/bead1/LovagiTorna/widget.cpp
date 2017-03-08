#include "widget.h"
#include "ui_widget.h"

Widget::Widget(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::Widget)
{
    v_layout = new QVBoxLayout(this);
    h_layout = new QHBoxLayout(this);
    //setup restart button
    restart_button = new QPushButton(QString::fromAscii("Restart"));
    connect(restart_button, SIGNAL(clicked(bool)), this, SLOT(restartGame()));
    //initialize dropdown list of game sizes
    game_size_dropdown = new QComboBox();
    game_size_dropdown->addItem(QString::fromUtf8("8×8"));
    game_size_dropdown->addItem(QString::fromUtf8("6×6"));
    game_size_dropdown->addItem(QString::fromUtf8("4×4"));
    //initialize layouts
    h_layout->addStretch(2);
    h_layout->addWidget(game_size_dropdown, 1);
    h_layout->addWidget(restart_button, 1);
    h_layout->addStretch(2);
    cbl = new QChessBoardLayout(8, this);
    connect(cbl, SIGNAL(gameFinished(Player)), this, SLOT(finishedGame(Player)));
    v_layout->addLayout(h_layout);
    v_layout->addLayout(cbl);
    this->setLayout(v_layout);
    ui->setupUi(this);
}

Widget::~Widget()
{
    delete cbl;
    delete v_layout;
    delete h_layout;
    delete game_size_dropdown;
    delete restart_button;
    delete ui;
}

void Widget::restartGame() {
    if(!cbl->gameFinished()) {
        QMessageBox mb(
            QMessageBox::Question,
            QString::fromAscii("Restart game?"),
            QString::fromAscii("Your game is in progress! Are you sure you want to restart with the selected board size?"),
            QMessageBox::Yes | QMessageBox::No
        );
        int result = mb.exec();
        if(result == QMessageBox::No) {
            return;
        }
    }
    delete cbl;
    int size = 8 - game_size_dropdown->currentIndex() * 2;
    cbl = new QChessBoardLayout(size, this);
    connect(cbl, SIGNAL(gameFinished(Player)), this, SLOT(finishedGame(Player)));
    v_layout->addLayout(cbl);
    this->adjustSize();
}

void Widget::finishedGame(Player winner) {
    QString text;
    switch(winner) {
    case Game::Player::White:
        text = QString("Congratulations!\nThe White player won!");
        break;
    case Game::Player::Black:
        text = QString("Congratulations!\nThe Black player won!");
        break;
    default:
        text = QString("Unable to detect winner");
        break;
    }
    QMessageBox mb(
        QMessageBox::NoIcon,
        QString::fromAscii("Congratulations!"),
        text,
        QMessageBox::Ok
    );
    mb.exec();
}
