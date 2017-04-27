#ifndef GAMEPERSISTENCE_H
#define GAMEPERSISTENCE_H

#include "savedata.h"

class GamePersistence
{
public:
    GamePersistence() {}
    virtual void save(const SaveData& data) = 0;
    virtual void load(SaveData& data) = 0;
    virtual ~GamePersistence() {}
};

#endif // GAMEPERSISTENCE_H
