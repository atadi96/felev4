#include "mainwidget.h"
#include "ui_mainwidget.h"

#include <QBoxLayout>
#include "View/gamewidget.h"

MainWidget::MainWidget(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::MainWidget)
{
    QBoxLayout* bl = new QBoxLayout(QBoxLayout::LeftToRight);
    bl ->addWidget(new GameWidget());
    setLayout(bl);
    ui->setupUi(this);
}

MainWidget::~MainWidget()
{
    delete ui;
}
