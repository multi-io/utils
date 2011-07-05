#include <iostream>

using namespace std;

template <typename T, typename Superclass> class ConstrainedCollection: public Superclass {
public:
    virtual void push_back(T x) {
        if (Superclass::size() > 5) {
            throw 42;
        }
        cout << "fuege Element hinzu: " << x << endl;
        Superclass::push_back(x);
    }
};


#include <vector>




int main() {
    try {
        ConstrainedCollection<int, vector<int> > arr;
        arr.push_back(1);
        arr.push_back(2);
        arr.push_back(3);
        arr.push_back(4);
        arr.push_back(5);
        arr.push_back(6);
        arr.push_back(7);
        arr.push_back(8);
        arr.push_back(9);
    }
    catch (int err) {
        cout <<  "Fehler: " << err << endl;
    }
}
