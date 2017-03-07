#ifndef QCHESSBOARDLAYOUT_H
#define QCHESSBOARDLAYOUT_H

#include <QObject>
#include <QGridLayout>
#include <qboardbutton.h>
#include "game/game.h"
#include "game/enums.h"

class QChessBoardLayout : public QGridLayout
{
    Q_OBJECT

private:
    Game::Game game;
    QVector<QBoardButton*> btnVector;
public:
    QChessBoardLayout(int game_size, QWidget* parent);
    ~QChessBoardLayout();
private:
    void redraw();
signals:
    void gameFinished(Game::Player winner);
};

#endif // QCHESSBOARDLAYOUT_H
