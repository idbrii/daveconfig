// setlocal makeprg=c:/sandbox/build_cpp.bat\ %
#include <iostream>
#include <cstdint>
using std::cout;
using std::endl;

int main()
{

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
