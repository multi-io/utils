#include <stdio.h>


class Integer {
    int i;
public:
    void set(int ii) {
        i = ii;
    }

    int get() const {
        return i;
    }
};


class IntPair {

    Integer a,b;

public:
    int getA() const {
        return a.get();
    }

    Integer getB() const {
        return b;
    }

    void setA(int i) {
        a.set(i);
    }

    void setB(int i) {
        b.set(i);
    }

};


int main() {
    IntPair ip;

    ip.setA(27);
    ip.setB(100);

    printf("%i\n\n",ip.getB().get());

    return 0;
}
