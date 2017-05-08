#-------------------------------------------------
#
# Project created by QtCreator 2017-04-28T13:57:03
#
#-------------------------------------------------

QT       += testlib

QT       -= gui

TARGET = tst_squarestesttest
CONFIG   += console
CONFIG   -= app_bundle

TEMPLATE = app


SOURCES += tst_squarestesttest.cpp \
    ../../Squares/Model/game.cpp \
    ../../Squares/Persistence/filepersistence.cpp \
    ../../Squares/Persistence/mockpersistence.cpp
DEFINES += SRCDIR=\\\"$$PWD/\\\"

HEADERS += \
    ../../Squares/Model/game.h \
    ../../Squares/Persistence/filepersistence.h \
    ../../Squares/Persistence/gamepersistence.h \
    ../../Squares/Persistence/mockpersistence.h \
    ../../Squares/Persistence/savedata.h

RESOURCES += \
    resources.qrc
