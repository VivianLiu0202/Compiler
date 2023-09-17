;常量在使用的时候直接使用数值进行替换，比如SIZE=6，在后续的arr定义中直接使用6
;创建全局变量的数组
@arr = dso_local global [6 x i32] zeroinitializer align 4

define dso_local noundef i1 @_isOddNumber(i32 %0) #4 {
    ;分配存储空间来存储一个i32类型的变量（%2）和一个i8（8位整数）类型的变量（%3）
    %2=alloca i32,align 4 ;用来存n，也就是%0
    %3=alloca i1;对应C++代码中的isOdd

    ;将函数的输入n存放在%2中，将1也就是true赋值给%3，也就是isOdd初始化为true
    store i32 %0,i32* %2,align 4
    store i1 1,i1* %3

    ;把%2的值加载到%4，计算%4%2的值，放入%5
    %4=load i32,i32* %2,align 4
    %5=srem i32 %4, 2
    ;如果%5是0，让%6包含true，否则包含false
    %6=icmp eq i32 %5, 0 ;将%5与0进行比较，icmp是整数比较，返回一个i1的值（bool值）

    ;如果%6是true，也就是n为偶数，跳转到标签7，否则跳转到标签8
    ;br创建条件分支，if-else
    br i1 %6,label %7,label %8

7:
    ;在标签%7中，将0存储在%3中，表示isOdd=false
    ;然后无条件跳转到标签%8
    store i1 0,i1* %3
    br label %8

8:                                               
    ;在标签%8中，从%3中加载值到%9，然后将%9截断为i1类型，结果存储在%10中
    %9 = load i1, i1* %3
    ;%10 = trunc i8 %9 to i1 ;这一句似乎可以进行修改，将i8一开始就定义为i1
    ;保证返回类型是个bool而不是一个i8

    ;返回一个i1（bool型）变量
    ret i1 %9
}