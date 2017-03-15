#ifndef KEYBOARD_H
#define KEYBOARD_H

#include <QKeyEvent>
#include "keyboardstate.h"

class Keyboard
{
private:
    Keyboard();
    static KeyboardState m_state;
public:
    static const KeyboardState& getState();
    static void keyPressEvent(QKeyEvent* event);
    static void keyReleaseEvent(QKeyEvent* event);
private:
    static void update(QKeyEvent* event, bool pressed);
};

#endif // KEYBOARD_H
