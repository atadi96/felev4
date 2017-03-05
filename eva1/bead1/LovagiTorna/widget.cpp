#include "widget.h"
#include "ui_widget.h"

Widget::Widget(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::Widget)
{
    gl = new QGridLayout(this);
    gl->setSpacing(0);
    this->setLayout(gl);
    for(int i = 0; i < 64; ++i) {
        QPushButton* btn = new QPushButton();
        btn->setText((i%2==0)!=((i/8)%2==0)?QString("FEKETE"):QString("feher"));
        btn->setProperty("chess-color", (i%2==0)!=((i/8)%2==0)?"black":"white");
        gl->addWidget(btn, i/8, i%8);
        btnVector.push_back(btn);
    }
    ui->setupUi(this);
}

Widget::~Widget()
{
    for(QVector<QPushButton*>::iterator it = btnVector.begin(); it != btnVector.end(); ++it) {
        delete *it;
    }
    delete ui;
}
