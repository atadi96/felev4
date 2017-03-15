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
    Map(int height, int width);
    Map(QString filename);
    bool contains(const QPoint& point) const;
    bool contains(int x, int y) const;
    QRect bounds() const;
    QSize size() const;
    const MapRow& operator[](int index) const;
    ~Map();

};

#endif // MAP_H
