#include "mainwidget.h"
#include "ui_mainwidget.h"

MainWidget::MainWidget(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::MainWidget)
{
    gw = new GameWidget(this);
    setFixedSize(gw->size());
    ui->setupUi(this);
}

MainWidget::~MainWidget()
{
    delete gw;
    delete ui;
}
