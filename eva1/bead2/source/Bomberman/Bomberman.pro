#-------------------------------------------------
#
# Project created by QtCreator 2017-03-14T17:16:14
#
#-------------------------------------------------

QT       += core gui

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = Bomberman
TEMPLATE = app


SOURCES += main.cpp\
        mainwidget.cpp \
    gamecalc.cpp \
    game_calc/entity.cpp

HEADERS  += mainwidget.h \
    gamecalc.h \
    game_calc/entity.h

FORMS    += mainwidget.ui
