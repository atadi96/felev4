#include <QString>
#include <QtTest>

class SquaresTestTest : public QObject
{
    Q_OBJECT

public:
    SquaresTestTest();

private Q_SLOTS:
    void testCase1();
};

SquaresTestTest::SquaresTestTest()
{
}

void SquaresTestTest::testCase1()
{
    QVERIFY2(false, "Failure");
}

QTEST_APPLESS_MAIN(SquaresTestTest)

#include "tst_squarestesttest.moc"
