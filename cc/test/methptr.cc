#include <iostream>

using namespace std;


class TheClass {
public:

    void theMethod(int i) {
        cout << this << "theMethod" << i << endl;
    }
};

int main() {
    void (TheClass::*MyMethPointer) (int);
    MyMethPointer = &TheClass::theMethod;

    TheClass theInstance;
    (theInstance.*MyMethPointer)(42);
}
