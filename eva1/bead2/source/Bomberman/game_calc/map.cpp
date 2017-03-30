#include "map.h"
#include <QFile>
#include <QTextStream>

Map::Map(int width, int height) : m_size(width, height), m_bounds(QPoint(0, 0), m_size) {
    for(int x = 0; x < width; ++x) {
        MapRow row;
        for(int y = 0; y < height; ++y) {
            FieldEntity* field = new FieldEntity(FieldType::Ground);
            field->setPos(QPoint(x, y));
            row.push_back(field);
        }
        m_fields.push_back(row);
    }
}

Map::Map(const QString& filename) {
    QFile mapFile(filename);
    if(mapFile.open(QIODevice::ReadOnly)) {
        QTextStream in(&mapFile);
        m_name = in.readLine();
        int width, height;
        in >> width;
        in >> height;
        in.readLine();
        m_size = QSize(width, height);
        m_bounds = QRect(QPoint(0,0), m_size);
        for(int row = 0; row < height; ++row) {
            MapRow map_row;
            QString line = in.readLine();
            int col = 0;
            for(auto it = line.begin(); col < width && it != line.end(); ++it) {
                switch(it->unicode()) {
                case '#': {
                    FieldEntity* entity = new FieldEntity(FieldType::Wall);
                    entity->setPos(QPoint(col, row));
                    setEntityName(entity, col, row);
                    map_row.push_back(entity);
                    break; }
                case 'p': {
                    FieldEntity* entity = new FieldEntity(FieldType::Ground);
                    entity->setPos(QPoint(col, row));
                    setEntityName(entity, col, row);
                    map_row.push_back(entity);
                    m_player_pos = QPoint(col, row);
                    break; }
                case 'e': {
                    FieldEntity* entity = new FieldEntity(FieldType::Ground);
                    entity->setPos(QPoint(col, row));
                    setEntityName(entity, col, row);
                    map_row.push_back(entity);
                    m_enemy_poss.push_back(QPoint(col, row));
                    break; }
                case ' ':
                default: {
                    FieldEntity* entity = new FieldEntity(FieldType::Ground);
                    entity->setPos(QPoint(col, row));
                    setEntityName(entity, col, row);
                    map_row.push_back(entity);
                    break; }
                }
                ++col;
            }
            m_fields.push_back(map_row);
        }
    } else {
        qDebug("Fatal Error: Unable to load map!");
        qDebug(mapFile.errorString().toStdString().c_str());
        throw 42;
    }
    qDebug("Map constructor done");
}

QString Map::name() const {
    return m_name;
}

void Map::setEntityName(FieldEntity *entity, int col, int row) {
    entity->setName(QString("Map field ") + QString::number(col) + QString(",") + QString::number(row));
}

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

const QPoint& Map::player_pos() const {
    return m_player_pos;
}
const QVector<QPoint>& Map::enemy_pos() const {
    return m_enemy_poss;
}

FieldEntity* Map::field(const QPoint& pos) const {
    return m_fields.at(pos.y()).at(pos.x());
}

Map::~Map() {
    for(int x = 0; x < m_size.width(); ++x) {
        for(int y = 0; y < m_size.height(); ++y) {
            delete m_fields[x][y];
        }
    }
}
