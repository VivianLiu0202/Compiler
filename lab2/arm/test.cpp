//用来实现条件判断语句、运算等SysY特性的样例程序
#include<iostream>
using namespace std;
int main()
{
    int num;
    cout<<"Please input a number:";
    cin>>num;

    if(num<=1)
    {
        cout<<"Not Prime"<<endl;
        return 0;
    }

    int i = 2;
    bool isPrime = true;
    while(i*i<=num)
    {
        if(num%i == 0)
        {
            isPrime = false;
            break;
        }
        i++;
    }

    if(isPrime)
    {
        cout<<"Is Prime"<<endl;
    }
    else
    {
        cout<<"Not Prime"<<endl;
    }
    return 0;

}