#-------------------------------------------------
#
# Project created by QtCreator 2017-03-30T23:43:36
#
#-------------------------------------------------

QT       += testlib

QT       -= gui

TARGET = tst_unit_testtest
CONFIG   += console
CONFIG   -= app_bundle

TEMPLATE = app


SOURCES += tst_unit_testtest.cpp \
    ../../game_calc/map.cpp \
    ../../game_calc/entities/bombentity.cpp \
    ../../game_calc/entities/direction.cpp \
    ../../game_calc/entities/enemyentity.cpp \
    ../../game_calc/entities/entity.cpp \
    ../../game_calc/entities/fieldentity.cpp \
    ../../game_calc/entities/movingentity.cpp \
    ../../game_calc/entities/playerentity.cpp
DEFINES += SRCDIR=\\\"$$PWD/\\\"

HEADERS += \
    ../../game_calc/map.h \
    ../../game_calc/entities/direction.h \
    ../../game_calc/entities/enemyentity.h \
    ../../game_calc/entities/movingentity.h \
    ../../game_calc/entities/bombentity.h \
    ../../game_calc/entities/entity.h \
    ../../game_calc/entities/entityhandler.h \
    ../../game_calc/entities/fieldentity.h \
    ../../game_calc/entities/playerentity.h
