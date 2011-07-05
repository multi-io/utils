#include <stdio.h>


class Enum {

public:
    virtual int elemCount() = 0;
    virtual int elemAt(int i) = 0;

    void printAllElements();
};


void Enum::printAllElements() {
    for (int i=0; i<elemCount(); i++) {
        printf("%i\n",elemAt(i));
    }
}





class MyBase {
public:
    void myBaseMeth1();
    virtual void myBaseMeth2();
    virtual void setIntArray(int* arr, int size) = 0;
};


void MyBase::myBaseMeth1() {
    printf("myBaseMeth1\n");
}

void MyBase::myBaseMeth2() {
    printf("myBaseMeth2\n");
}




class MyImpl : public MyBase, public Enum {
    int* arr;
    int size;
public:
    virtual void setIntArray(int* arr, int size);
    virtual int elemCount();
    virtual int elemAt(int i);
};


void MyImpl::setIntArray(int* arr, int size) {
    this->arr = arr;
    this->size = size;
}

int MyImpl::elemCount() {
    return size;
}

int MyImpl::elemAt(int i) {
    return arr[i];
}



int main() {
    MyImpl myimpl1;
    int arr[] = {5,7,2,4,1,2};
    myimpl1.setIntArray(arr, sizeof(arr)/sizeof(arr[0]));
    myimpl1.printAllElements();
}
