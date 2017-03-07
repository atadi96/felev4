#ifndef QBOARDBUTTON_H
#define QBOARDBUTTON_H

#include <QPushButton>
#include <QString>
#include <string>
#include "game/game.h"


typedef std::string string;

class QBoardButton : public QPushButton
{
    Q_OBJECT
    Q_PROPERTY(int color READ color WRITE setColor)
    Q_PROPERTY(int piece READ piece WRITE setPiece)

public:
    QBoardButton(QWidget * parent = 0) : QPushButton(parent), m_color(1) {  }
    QBoardButton(const QString & text, QWidget * parent = 0) : QPushButton(text, parent), m_color(1) {}
    QBoardButton(const QIcon & icon, const QString & text, QWidget * parent = 0) : QPushButton(icon, text, parent), m_color(1) {}
    void setColor(int color);
    int color() const;
    void setPiece(int piece);
    int piece() const;

private:
    int m_color;
    int m_piece;
};

#endif // QBOARDBUTTON_H
