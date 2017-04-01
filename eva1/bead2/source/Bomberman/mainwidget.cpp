#include "mainwidget.h"
#include "ui_mainwidget.h"

MainWidget::MainWidget(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::MainWidget)
{
    vBoxLayout = new QVBoxLayout(this);
    label = new QLabel(QString::fromUtf8("Select a map!"));
    label->setAlignment(Qt::AlignCenter);
    vBoxLayout->addWidget(label, 1);
    setupButton(storageButton, "Storage room");
    setupButton(meadowButton, "Meadows");
    setupButton(ruinsButton, "Ruins");
    connect(storageButton, SIGNAL(clicked(bool)), SLOT(storageClick(bool)));
    connect(meadowButton, SIGNAL(clicked(bool)), SLOT(meadowClick(bool)));
    connect(ruinsButton, SIGNAL(clicked(bool)), SLOT(ruinsClick(bool)));
    ui->setupUi(this);
    setWindowTitle("Bomberman");
}

MainWidget::~MainWidget()
{
    clearWidget(label);
    clearWidget(storageButton);
    clearWidget(meadowButton);
    clearWidget(ruinsButton);
    delete vBoxLayout;
    delete ui;
}

void MainWidget::setupButton(QPushButton*& button, const char* text) {
    button = new QPushButton(QString::fromUtf8(text));
    button->setSizePolicy(QSizePolicy::Expanding, QSizePolicy::Expanding);
    vBoxLayout->addWidget(button, 1);
}

void MainWidget::clearWidget(QWidget* widget) {
    vBoxLayout->removeWidget(widget);
    delete widget;
}

void MainWidget::storageClick(bool) {
    GameDialog* gd = new GameDialog(":/resources/maps/02.map");
    gd->exec();
    delete gd;
}

void MainWidget::meadowClick(bool) {
    GameDialog* gd = new GameDialog(":/resources/maps/01.map");
    gd->exec();
    delete gd;
}

void MainWidget::ruinsClick(bool) {
    GameDialog* gd = new GameDialog(":/resources/maps/03.map");
    gd->exec();
    delete gd;
}
