#ifndef MAP_H
#define MAP_H

#include <QVector>
#include <QRect>
#include <QPoint>
#include <QSize>
#include <QString>
#include "entities/fieldentity.h"


typedef QVector<FieldEntity*> MapRow;

class Map
{
private:
    QSize m_size;
    QRect m_bounds;
    QVector<MapRow> m_fields;
    QPoint m_player_pos;
    QVector<QPoint> m_enemy_poss;
public:
    Map(int width, int height);
    Map(const QString& filename);
    bool contains(const QPoint& point) const;
    bool contains(int x, int y) const;
    const QPoint& player_pos() const;
    const QVector<QPoint>& enemy_pos() const;
    QRect bounds() const;
    QSize size() const;
    QVector<MapRow>& fields();
    FieldEntity* field(const QPoint& pos) const;
    ~Map();

};

#endif // MAP_H
