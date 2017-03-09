#ifndef QCHESSBOARDLAYOUT_H
#define QCHESSBOARDLAYOUT_H

#include <QObject>
#include <QGridLayout>
#include <qboardbutton.h>
#include "game/game.h"
#include "game/enums.h"

typedef Game::Player Player;

class QChessBoardLayout : public QGridLayout
{
    Q_OBJECT

private:
    Game::Game game;
    QVector<QBoardButton*> btnVector;
public:
    QChessBoardLayout(int game_size, QWidget* parent = 0);
    bool gameFinished() const;
    ~QChessBoardLayout();
signals:
    void gameFinished(Player winner);
private slots:
    void fieldClick();
    void redraw();
};

#endif // QCHESSBOARDLAYOUT_H
