#include "map.h"

Map::Map(int height, int width) : m_size(width, height), m_bounds(QPoint(0, 0), m_size) {
    for(int x = 0; x < height; ++x) {
        for(int y = 0; y < width; ++y) {
            FieldEntity* field = new FieldEntity(FieldType::Ground);
            field->setPos(QPoint(x, y));
            m_fields[x].push_back(field);
        }
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
const MapRow& Map::operator[](int index) const {
    return m_fields[index];
}

Map::~Map() {
    for(int x = 0; x < m_size.height(); ++x) {
        for(int y = 0; y < m_size.width(); ++y) {
            delete m_fields[x][y];
        }
    }
}
