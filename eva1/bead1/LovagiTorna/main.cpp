#include "widget.h"
#include <QApplication>

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    a.setStyleSheet("QPushButton {"
                    "   border-width: 1px;"
                    "   border-style: solid;"
                    "   border-color: black;"
                    "   background-color: gray;"
                    "   width: 75px;"
                    "   height: 75px;"
                    "   outline:none;"
                    "}"
                    "QPushButton:hover {"
                    "   border: 3px solid #00A000;"
                    "}"
                    "QPushButton:focus {"
                    "   border: 3px solid red;"
                    "}"
                    "QPushButton:focus:hover {"
                    "   border: 3px dotted red;"
                    "}"
                    "*[chess-color=\"white\"] {"
                    "   background-color: #FFFFFF;"
                    "   color: #000000;"
                    "}"
                    "*[chess-color=\"black\"] {"
                    "   background-color: #000000;"
                    "   color: #FFFFFF;"
                    "}");
    Widget w;
    w.show();

    return a.exec();
}
