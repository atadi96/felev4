#ifndef MAINWIDGET_H
#define MAINWIDGET_H

#include <QWidget>
#include "game_view/gamewidget.h"

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
    GameWidget *gw;
};

#endif // MAINWIDGET_H
