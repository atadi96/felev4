#-------------------------------------------------
#
# Project created by QtCreator 2017-03-04T20:16:39
#
#-------------------------------------------------

QT       += core gui

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = LovagiTorna
TEMPLATE = app


SOURCES += main.cpp\
        widget.cpp \
    qboardbutton.cpp \
    game/game.cpp \
    game/point.cpp

HEADERS  += widget.h \
    qboardbutton.h \
    game/game.h \
    game/point.h

FORMS    += widget.ui

RESOURCES += \
    resources.qrc
