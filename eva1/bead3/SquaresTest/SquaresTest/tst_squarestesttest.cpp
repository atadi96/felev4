#include <QString>
#include <QtTest>

#include "../../Squares/Model/game.h"
#include "../../Squares/Persistence/filepersistence.h"

class SquaresTestTest : public QObject
{
    Q_OBJECT

public:
    SquaresTestTest();

private:
    FilePersistence pers;
    Game game;
    Player last;
    void placeLine(const QPointF& place);

private Q_SLOTS:
    void putTop();
    void putLeft();
    void gameOver();
};

SquaresTestTest::SquaresTestTest() : pers(":/mock.sav"), game(&pers)
{
}

void SquaresTestTest::placeLine(const QPointF& place) {
    Maybe<QLine> line(game.highlightedLine(place));
    QVERIFY(!game.won());
    QVERIFY(line.has_value);
    game.click(place);
    {
        Maybe<QLine> line(game.highlightedLine(place));
        QVERIFY(!line.has_value);
    }
}

void SquaresTestTest::putTop() {
    placeLine(QPointF(0.5, 0));
    QVERIFY(game.squares()[0][0] == Player::None);
}

void SquaresTestTest::putLeft() {
    last = game.currentPlayer();
    placeLine(QPointF(0, 0.5));
}

void SquaresTestTest::gameOver() {
    QVERIFY(game.squares()[0][0] == last);
    QVERIFY(game.won());
    QVERIFY(game.currentPlayer() == last);
}



QTEST_APPLESS_MAIN(SquaresTestTest)

#include "tst_squarestesttest.moc"
