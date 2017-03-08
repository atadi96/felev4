#ifndef WIDGET_H
#define WIDGET_H

#include <QWidget>
#include <QGridLayout>
#include "qboardbutton.h"
#include "qchessboardlayout.h"

namespace Ui {
class Widget;
}

class Widget : public QWidget
{
    Q_OBJECT

public:
    explicit Widget(QWidget *parent = 0);
    ~Widget();

private:
    Ui::Widget *ui;
    QGridLayout *gl;
    QChessBoardLayout* cbl;
    QVector<QBoardButton*> btnVector;
};

#endif // WIDGET_H
