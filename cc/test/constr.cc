#include <stdio.h>

class A {
public:
    virtual void f();
};

void A::f() {
    printf("A::f\n");
}


class B {
public:
    B();
    virtual void f();
};

B::B() {
    f();
}

void B::f() {
    printf("B::f\n");
}



int main() {
    B *b = new B;
    B b2;
    return 0;
}
