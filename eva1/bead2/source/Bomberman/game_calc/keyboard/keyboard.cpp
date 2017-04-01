#include "keyboard.h"

KeyboardState Keyboard::m_state;

Keyboard::Keyboard() {
}

const KeyboardState& Keyboard::getState() {
    return m_state;
}

void Keyboard::keyPressEvent(QKeyEvent* event) {
    update(event, true);
}

void Keyboard::keyReleaseEvent(QKeyEvent* event) {
    update(event, false);
}

void Keyboard::update(QKeyEvent* event, bool pressed) {
    if(event->key() == Qt::Key_Space) {
        m_state.setKey(GameKey::Fire, pressed);
        event->accept();
    }
    if(event->key() == Qt::Key_Escape || event->key() == Qt::Key_Backspace) {
        m_state.setKey(GameKey::Pause, pressed);
        event->accept();
    }
    if(event->key() == Qt::Key_Left || event->key() == Qt::Key_A) {
        m_state.setKey(GameKey::Left, pressed);
        event->accept();
    }
    if(event->key() == Qt::Key_Right || event->key() == Qt::Key_D) {
        m_state.setKey(GameKey::Right, pressed);
        event->accept();
    }
    if(event->key() == Qt::Key_Up || event->key() == Qt::Key_W) {
        m_state.setKey(GameKey::Up, pressed);
        event->accept();
    }
    if(event->key() == Qt::Key_Down || event->key() == Qt::Key_S) {
        m_state.setKey(GameKey::Down, pressed);
        event->accept();
    }
}
