#include "point.h"

Point::Point() { }

Point& Point::operator+=(const Point& rhs) {
    m_x += rhs.x();
    m_y += rhs.y();
    return *this;
}

Point Point::operator+(const Point& rhs) const {
    Point tmp(*this);
    tmp += rhs;
    return tmp;
}
Point& Point::operator-=(const Point& rhs) {
    m_x -= rhs.x();
    m_y -= rhs.y();
    return *this;
}
Point Point::operator-(const Point& rhs) const {
    Point tmp(*this);
    tmp -= rhs;
    return tmp;
}

bool Point::operator==(const Point& rhs) const {
    return (m_x == rhs.m_x) && (m_y == rhs.m_y);
}
int Point::x() const {
    return m_x;
}
int Point::y() const {
    return m_y;
}
Point& Point::setX(int x) {
    m_x = x;
    return *this;
}

Point& Point::setY(int y) {
    m_y = y;
    return *this;
}

//see: http://stackoverflow.com/questions/17095324/fastest-way-to-determine-if-an-integer-is-between-two-integers-inclusive-with
bool Point::inRectangle(const Point& top_left, const Point& bottom_right) {
    return
            (top_left.x() <= m_x && m_x <= bottom_right.x()) &&
            (top_left.y() <= m_y && m_y <= bottom_right.y());
}

const Point Point::zero(0,0);
