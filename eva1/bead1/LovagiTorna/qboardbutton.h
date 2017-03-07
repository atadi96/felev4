#ifndef QBOARDBUTTON_H
#define QBOARDBUTTON_H

#include <QPushButton>
#include <QString>
#include <string>

struct BoardColor
{
    static const int Grey;
    static const int White;
    static const int Black;
};
struct PieceType
{
    static const int WhiteLeft;
    static const int WhiteRight;
    static const int BlackLeft;
    static const int BlackRight;
};

typedef std::string string;

class QBoardButton : public QPushButton
{
    Q_OBJECT
    Q_ENUMS(Piece)
    Q_PROPERTY(int color READ color WRITE setColor)
    Q_PROPERTY(int piece READ piece WRITE setPiece)

public:
    enum BoardColorEnum { Grey, Black, White};
    enum Piece {BlackLeft, BlackRight, WhiteLeft, WhiteRight};
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
