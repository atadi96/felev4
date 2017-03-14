#ifndef GAMECALC_H
#define GAMECALC_H

#include <QString>
#include <QVector>

class Map;
class Entity;

class GameCalc
{
private:
    Entity* _player;
    QVector<Entity*> _entities;
    Map _map;

public:
    GameCalc(QString map_file);
    Map map () const;
    QVector<Entity*> entities() const;
    void update(QTime time);

};

#endif // GAMECALC_H
