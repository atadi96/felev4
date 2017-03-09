#ifndef WIDGET_H
#define WIDGET_H

#include <QWidget>
#include <QVBoxLayout>
#include <QHBoxLayout>
#include <QPushButton>
#include <QComboBox>
#include <QMessageBox>
#include "qboardbutton.h"
#include "qchessboardlayout.h"

typedef Game::Player Player;

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
    QComboBox *game_size_dropdown;
    QVBoxLayout *v_layout;
    QHBoxLayout *h_layout;
    QPushButton *restart_button;

    QChessBoardLayout* cbl;
    QVector<QBoardButton*> btnVector;

private slots:
    void restartGame();
    void finishedGame(Player winner);
};

#endif // WIDGET_H
