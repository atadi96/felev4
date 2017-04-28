#include "mainwidget.h"
#include "ui_mainwidget.h"

MainWidget::MainWidget(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::MainWidget)
{
    mainLayout = new QVBoxLayout();
    buttonsLayout = new QHBoxLayout();
    restartLayout = new QVBoxLayout();

    restartButton = new QPushButton(QString::fromUtf8("Restart"));
    saveButton = new QPushButton(QString::fromUtf8("Save"));
    loadButton = new QPushButton(QString::fromUtf8("Load"));

    restartMapSize = new QComboBox(this);
    restartMapSize->addItem(QString::fromUtf8("3×3"));
    restartMapSize->addItem(QString::fromUtf8("5×5"));
    restartMapSize->addItem(QString::fromUtf8("9×9"));

    gameWidget = new GameWidget(3);

    restartLayout->addWidget(restartMapSize);
    restartLayout->addWidget(restartButton);
    buttonsLayout->addWidget(saveButton);
    buttonsLayout->addLayout(restartLayout);
    buttonsLayout->addWidget(loadButton);

    mainLayout->addLayout(buttonsLayout);
    mainLayout->addWidget(gameWidget);

    setLayout(mainLayout);

    connect(restartButton, SIGNAL(clicked(bool)), SLOT(restartClick()));
    connect(saveButton, SIGNAL(clicked(bool)), SLOT(saveClick()));
    connect(loadButton, SIGNAL(clicked(bool)), SLOT(loadClick()));

    ui->setupUi(this);
}

void MainWidget::saveClick() {
    gameWidget->save();
}

void MainWidget::loadClick() {
    mainLayout->removeWidget(gameWidget);
    delete gameWidget;
    gameWidget = new GameWidget();
    mainLayout->addWidget(gameWidget);
    updateGeometry();
}

void MainWidget::restartClick() {
    mainLayout->removeWidget(gameWidget);
    delete gameWidget;
    int mapSize;
    if(restartMapSize->currentIndex() < 2) {
        mapSize = restartMapSize->currentIndex() * 2 + 3;
    } else {
        mapSize = 9;
    }
    gameWidget = new GameWidget(mapSize);
    mainLayout->addWidget(gameWidget);
    updateGeometry();
}

MainWidget::~MainWidget()
{
    delete ui;
}
