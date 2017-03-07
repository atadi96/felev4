#ifndef POINT_H
#define POINT_H


class Point
{
private:
    int m_x, m_y;
public:
    Point();
    Point(int x, int y) : m_x(x), m_y(y) {}
    Point& operator+=(const Point& rhs);
    Point operator+(const Point& rhs) const;
    Point& operator-=(const Point& rhs);
    Point operator-(const Point& rhs) const;
    int x() const;
    int y() const;
    Point& setX(int x);
    Point& setY(int y);
    bool inRectangle(const Point& top_left, const Point& bottom_right);
    static const Point zero;
};

#endif // POINT_H
