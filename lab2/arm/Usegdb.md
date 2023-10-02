这是如何使用 `qemu-arm` 和 GDB 调试 ARM 二进制文件的步骤：

1. 在一个终端中启动 `qemu-arm` 并等待 GDB 连接：

```bash
qemu-arm -g 1234 ./prime
```

2. 在另一个终端中，使用 `arm-linux-gnueabihf-gdb`（或你的 ARM GDB 版本）连接到 QEMU：

```bash
arm-linux-gnueabihf-gdb ./prime
```

然后在 GDB 中：

```bash
(gdb) target remote :1234
(gdb) continue
``` 


1. **启动和连接**
   - `target remote :[port]`: 连接到远程调试会话，例如 QEMU。

2. **断点**
   - `break [function/line number]`: 在指定的函数或行号处设置断点。
   - `info breakpoints`: 列出所有设置的断点。
   - `delete [breakpoint number]`: 删除指定编号的断点。
   - `clear [function/line number]`: 删除在指定函数或行号处的断点。

3. **执行控制**
   - `run`: 开始执行程序。
   - `continue` 或 `c`: 继续执行程序，直到遇到下一个断点。
   - `next` 或 `n`: 执行下一行代码，但不进入函数。
   - `step` 或 `s`: 执行下一行代码，如果是函数则进入函数。
   - `finish`: 继续执行直到当前函数完成。
   - `quit` 或 `q`: 退出 GDB。

4. **查看和修改数据**
   - `print [expression]` 或 `p [expression]`: 打印表达式的值。
   - `set variable [variable]=[value]`: 设置变量的值。
   - `info locals`: 显示当前函数的局部变量。
   - `info registers`: 显示所有寄存器的值。

5. **堆栈操作**
   - `backtrace` 或 `bt`: 显示当前的调用堆栈。
   - `frame [number]`: 切换到指定的堆栈帧。
   - `up`: 移动到调用堆栈的上一帧。
   - `down`: 移动到调用堆栈的下一帧。

6. **其他**
   - `list` 或 `l`: 显示当前执行的源代码。
   - `disassemble` 或 `disas`: 反汇编当前函数或指定的地址。
   - `info proc`: 显示关于正在调试的进程的信息。
   - `help [command]`: 获取指定命令的帮助信息。
