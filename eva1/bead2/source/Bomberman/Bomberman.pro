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
    game_calc/gamecalc.cpp \
    game_calc/map.cpp \
    game_view/gamewidget.cpp \
    game_calc/entities/entity.cpp \
    game_calc/entities/fieldentity.cpp \
    game_calc/entities/movingentity.cpp \
    game_calc/entities/direction.cpp

HEADERS  += mainwidget.h \
    game_calc/gamecalc.h \
    game_calc/map.h \
    game_view/gamewidget.h \
    game_calc/entities/entity.h \
    game_calc/entities/entityhandler.h \
    game_calc/entities/fieldentity.h \
    game_calc/entities/movingentity.h \
    game_calc/entities/direction.h

FORMS    += mainwidget.ui

RESOURCES += \
    resources.qrc

DISTFILES +=
