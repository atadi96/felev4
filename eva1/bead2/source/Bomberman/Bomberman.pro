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
    game_calc/entities/direction.cpp \
    game_calc/keyboard/keyboardstate.cpp \
    game_calc/keyboard/keyboard.cpp \
    game_view/sprites/spritesystem.cpp \
    game_view/sprites/spritesequence.cpp \
    game_calc/entities/enemyentity.cpp \
    game_calc/entities/playerentity.cpp \
    game_calc/entities/bombentity.cpp \
    game_view/sprites/pixmapentitysprite.cpp \
    game_view/directionalpixmap.cpp

HEADERS  += mainwidget.h \
    game_calc/gamecalc.h \
    game_calc/map.h \
    game_view/gamewidget.h \
    game_calc/entities/entity.h \
    game_calc/entities/entityhandler.h \
    game_calc/entities/fieldentity.h \
    game_calc/entities/movingentity.h \
    game_calc/entities/direction.h \
    game_calc/keyboard/keyboardstate.h \
    game_calc/keyboard/keyboard.h \
    game_view/sprites/spritesystem.h \
    game_view/sprites/drawable.h \
    game_view/sprites/spritesequence.h \
    game_calc/entities/enemyentity.h \
    game_calc/entities/playerentity.h \
    game_calc/entities/bombentity.h \
    game_view/sprites/pixmapentitysprite.h \
    game_view/directionalpixmap.h

FORMS    += mainwidget.ui

RESOURCES += \
    resources.qrc

DISTFILES +=
