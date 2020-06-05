# Refined C Compiler

A new language compiler defined by grammar in guidebook of Compiling Principle in Njtech University. For detailed instructions, please read the pdf file in ./doc

## What is it?

A homework made for handling Compiler Principle courses. This project is using **lex** and **yacc**, also known as **flex** and **bison**. If there is anyone taking this course in Njtech University, this might help you **A LOT**.

## How to use it?

1. **Download and install your own flex, bison and makefile environment, as all of them are the basic tools for cooking the whole project**. As for how to achieve that, you should search for it in yourself.
2. `git clone https://github.com/Autokaka/refined_c_compiler.git`
3. In termial, input:
   - `make` to compile the compiler. The build files shall be generated “build” directory in your project root directory.
   - `make demo` to compile and run an example file to help you understand how to use this simple compiler.
   - `make clean` to clean the generated files and build files.
4. **if you don’t have Makefile environment**, you can run these commands in the root directory of your project in terminal:
   - `./make_all.sh` to compile the compiler. The build files shall be generated “build” directory in your project root directory.
   - `./make_demo.sh` to compile and run an example file to help you understand how to use this simple compiler.
   - `./make_clean.sh` to clean the generated files and build files.

## What’s more

1. If you need to know the detailed technique about how the script take effect, you can see all of them in `make_all.sh`, `make_clean.sh` and `make_demo.sh`. Talk is cheap in learning new things, you should always read the code :)

2. **Please notice that the “C” here does not mean that c/c++ language.** The language itself has its own rules. The format of your code should follow the definition in ./doc/编译原理上机实验指导书.pdf and ./doc/修改好的LL(1)文法.md

3. The whole project is built under the following environment. If you have problem in running scripts, please check if you meet the requirements below:

   - OS: Mac OS Catalina 10.15.5

   - Tools:

     flex 2.5.35 Apple(flex-32)

     bison (GNU Bison) 2.3

     Apple clang version 11.0.3 (clang-1103.0.32.62) Target: x86_64-apple-darwin19.5.0 Thread model: posix

4. Here is the tutorial about how to install lex and yacc: https://www.youtube.com/watch?v=8EO5Y7KhoeU. It is a Youtube link, if you are in a country that cannot access foreign website, please use a VPN first.
