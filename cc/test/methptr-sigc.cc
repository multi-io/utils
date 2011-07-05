#include <iostream>
#include <string>
#include <sigc++/signal_system.h>

#ifdef SIGC_CXX_NAMESPACES
using namespace SigC;
#endif


class TheClass : public Object {
public:

    void theMethod(int i) {
        cout << this << "theMethod" << i << endl;
    }
};

main()
{
    TheClass theInstance;

    Signal1<void,int> MyMethPointer;
    MyMethPointer.connect(slot(theInstance,&TheClass::theMethod));

    MyMethPointer(42);
}
