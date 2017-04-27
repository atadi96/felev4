#include "filepersistence.h"
#include <QFile>
#include <QTextStream>

FilePersistence::FilePersistence()
{

}

void FilePersistence::save(const SaveData& data) {
    QFile file(filename);
    if(file.open(QIODevice::WriteOnly)) {
        QTextStream ts(&file);
        ts << data.mapSize << endl;
        ts << static_cast<int>(data.currentPlayer) << endl;
        ts << data.uncoloredLines << " " << data.bluePoints << " "
           << data.redPoints << " " << data.won << endl;
        for(int y = 0; y < data.mapSize; ++y) {
            for(int x = 0; x < data.mapSize; ++x) {
                ts << static_cast<int>(data.squares[x][y]);
                if(x+1 != data.mapSize) {
                    ts << " ";
                } else {
                    ts << endl;
                }
            }
        }
        for(auto line : data.lines) {
            ts << line.p1().x() << " " << line.p1().y() << " "
               << line.p2().x() << " " << line.p2().y() << endl;
        }
    }
}

void FilePersistence::load(SaveData& data) {
    QFile file(filename);
    if(file.open(QIODevice::ReadOnly)) {
        QTextStream ts(&file);
        int temp;
        int x0, y0, x1, y1;
        ts >> data.mapSize;
        ts >> temp;
        data.currentPlayer = static_cast<Player>(temp);
        ts >> data.uncoloredLines;
        ts >> data.bluePoints;
        ts >> data.redPoints;
        ts >> temp;
        data.won = (bool)temp;
        for(int y = 0; y < data.mapSize; ++y) {
            for(int x = 0; x < data.mapSize; ++x) {
                ts >> temp;
                data.squares[x][y] = static_cast<Player>(temp);
            }
        }
        while(!ts.atEnd()) {
            ts >> x0;
            ts >> y0;
            ts >> x1;
            ts >> y1;
            data.lines.insert(QLine(x0, y0, x1, y1));
        }
    }
}
