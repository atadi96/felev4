#ifndef MAINWIDGET_H
#define MAINWIDGET_H

#include <QWidget>
#include <QVBoxLayout>
#include <QHBoxLayout>
#include <QPushButton>
#include <QComboBox>

#include "View/gamewidget.h"

namespace Ui {
class MainWidget;
}

class MainWidget : public QWidget
{
    Q_OBJECT

public:
    explicit MainWidget(QWidget *parent = 0);
    ~MainWidget();

private:
    Ui::MainWidget *ui;
    QVBoxLayout* mainLayout;
    QHBoxLayout* buttonsLayout;
    QVBoxLayout* restartLayout;
    QPushButton* restartButton;
    QComboBox* restartMapSize;
    QPushButton* saveButton;
    QPushButton* loadButton;

    GameWidget* gameWidget;

public slots:
    void saveClick();
    void loadClick();
    void restartClick();

};

#endif // MAINWIDGET_H
