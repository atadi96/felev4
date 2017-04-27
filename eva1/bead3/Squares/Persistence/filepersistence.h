#ifndef FILEPERSISTENCE_H
#define FILEPERSISTENCE_H

#include "gamepersistence.h"
#include <QString>

class FilePersistence : public GamePersistence
{
private:
    const QString filename = "game.sav";
public:
    FilePersistence();
    virtual void save(const SaveData& data) override;
    virtual void load(SaveData& data) override;
    virtual ~FilePersistence() {}
};

#endif // FILEPERSISTENCE_H
