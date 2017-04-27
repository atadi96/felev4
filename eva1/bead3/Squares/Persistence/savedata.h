#ifndef SAVEDATA_H
#define SAVEDATA_H

#include "Model/game.h"

struct SaveData
{
    int mapSize;
    Player currentPlayer;
    Game::square_container squares;
    Game::line_container lines;
    int uncoloredLines;
    int bluePoints;
    int redPoints;
    bool won;
};

#endif // SAVEDATA_H
