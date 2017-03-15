#include "map.h"

Map::Map(int width, int height) : m_size(width, height), m_bounds(QPoint(0, 0), m_size) {
    for(int x = 0; x < width; ++x) {
        MapRow row;
        for(int y = 0; y < height; ++y) {
            FieldEntity* field = new FieldEntity(FieldType::Ground/*y%2==0 ? FieldType::Ground : FieldType::Wall*/);
            field->setPos(QPoint(x, y));
            row.push_back(field);
        }
        m_fields.push_back(row);
    }
}

Map::Map(QString filename) {}

bool Map::contains(const QPoint& point) const {
    return m_bounds.contains(point, false);
}
bool Map::contains(int x, int y) const {
    return contains(QPoint(x, y));
}
QRect Map::bounds() const {
    return m_bounds;
}
QSize Map::size() const {
    return m_size;
}
QVector<MapRow>& Map::fields() {
    return m_fields;
}

Map::~Map() {
    for(int x = 0; x < m_size.width(); ++x) {
        for(int y = 0; y < m_size.height(); ++y) {
            delete m_fields[x][y];
        }
    }
}
