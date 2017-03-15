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
public:
    Map(int width, int height);
    Map(QString filename);
    bool contains(const QPoint& point) const;
    bool contains(int x, int y) const;
    QRect bounds() const;
    QSize size() const;
    QVector<MapRow>& fields();
    ~Map();

};

#endif // MAP_H
