#include "keyboardstate.h"

KeyboardState::KeyboardState(){
    m_pressed_keys.reset();
}

bool KeyboardState::isKeyDown(GameKey key) const {
    return m_pressed_keys[static_cast<unsigned int>(key)];
}

void KeyboardState::setKey(GameKey key, bool pressed) {
    if(pressed && !isKeyDown(key)) {
        m_last_pressed = key;
    }
    m_pressed_keys.set(static_cast<unsigned int>(key), pressed);
}

const GameKey& KeyboardState::last_pressed() const {
    return m_last_pressed;
}
