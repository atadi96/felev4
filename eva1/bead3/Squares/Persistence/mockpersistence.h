#ifndef MOCKPERSISTENCE_H
#define MOCKPERSISTENCE_H

#include "filepersistence.h"

class MockPersistence : public FilePersistence
{
protected:
    const QString filename;
public:
    MockPersistence() : filename("mock.sav") {}
    ~MockPersistence() noexcept {}
};

#endif // MOCKPERSISTENCE_H
