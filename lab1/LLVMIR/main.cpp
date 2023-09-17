#include<iostream>
using namespace std;
const int SIZE = 6;
int arr[SIZE];

bool isOddNumber(int n)
{
    bool isOdd = true;
    if(n%2==0) 
        isOdd = false;
    return isOdd;
}

int main()
{
    /*This Program is ordered to find the numbers whose value is odd 
     * and to caculate the average of those numbers!
    */
    int i = 0;
    int testand = 1;
    //The variable "testand" is designed to test logical operations.
    while(i < SIZE && testand == 1)
    {
        cin>>arr[i];
        i++;
    }

    double sum = 0;
    int count = 0;
    i=0;
    while(i<SIZE)
    {
        if(isOddNumber(arr[i]) == true)
        {
            sum += arr[i];
            count++;
        }
        i++;
    }
    double average = sum/count;
    cout<<average<<endl;
    return 0;
}

