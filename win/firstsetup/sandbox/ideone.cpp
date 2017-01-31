// setlocal makeprg=d:/sandbox/build.bat\ %
#include <iostream>
#include <cstdint>
using std::cout;
using std::endl;

class Interface {
public:
    virtual bool IsGood() const { return true; }
};

class Hello : public Interface {
public:
    static const int ArraySize = 5;
    int Array[ArraySize];
};

 
class Bye : public Hello {
public:
    virtual bool IsGood() const override { return true; }
};

 
int main()
{
    Hello h;
    cout << h.ArraySize << endl << endl;

    cout << sizeof(size_t) << endl;
    cout << sizeof(int*) << endl;
    cout << sizeof(int) << endl;
    cout << sizeof(int32_t) << endl;
    cout << sizeof(int64_t) << endl;

    const int i = 1;
    switch (i)
    {
        default:
            cout << "default: " << i << endl;
        case 1:
            cout << "explicit: " << i << endl;
    }

    return 0;
}
