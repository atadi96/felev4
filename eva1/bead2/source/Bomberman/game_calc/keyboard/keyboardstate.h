#ifndef KEYBOARDSTATE_H
#define KEYBOARDSTATE_H

#include <bitset>

enum class GameKey : unsigned int
{
    Up = 0x01,
    Down = 0x02,
    Left = 0x03,
    Right = 0x04,
    Fire = 0x05,
    Pause = 0x06
};

class KeyboardState
{
private:
    GameKey m_last_pressed = GameKey::Pause;
    std::bitset<6> m_pressed_keys;
public:
    KeyboardState();
    bool isKeyDown(GameKey key) const;
    void setKey(GameKey key, bool pressed);
    const GameKey& last_pressed() const;
};

#endif // KEYBOARDSTATE_H
