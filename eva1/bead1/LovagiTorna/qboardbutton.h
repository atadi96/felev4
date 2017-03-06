#ifndef QBOARDBUTTON_H
#define QBOARDBUTTON_H

#include <QPushButton>
#include <QString>

class BoardColor
{
public:
    static const int Grey;
    static const int White;
    static const int Black;
};

class QBoardButton : public QPushButton
{
    Q_OBJECT
    Q_ENUMS(Piece)
    Q_PROPERTY(int color READ color WRITE setColor)
    Q_PROPERTY(Piece piece READ piece WRITE setPiece)

public:
    enum BoardColorEnum { Grey, Black, White};
    enum Piece {BlackLeft, BlackRight, WhiteLeft, WhiteRight};
    QBoardButton(QWidget * parent = 0) : QPushButton(parent), m_color(1) {}
    QBoardButton(const QString & text, QWidget * parent = 0) : QPushButton(text, parent), m_color(1) {}
    QBoardButton(const QIcon & icon, const QString & text, QWidget * parent = 0) : QPushButton(icon, text, parent), m_color(1) {}
    void setColor(int color);
    int color() const;
    void setPiece(Piece piece);
    Piece piece() const;

private:
    int m_color;
    Piece m_piece;
};

#endif // QBOARDBUTTON_H
