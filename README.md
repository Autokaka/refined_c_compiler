# Refined C Compiler

A language subset compiler defined by grammar in guide book of Compiling Principle in Njtech University. For detailed instructions, please read the pdf file in ./doc

## What is it?

A homework made for handling Compiler Principle courses. This project is using **lex** and **yacc**, also known as **flex** and **bison**. If there is anyone taking this course in Njtech University, this might help you **A LOT**.

## How to use it?

1. **Download and install your own lex and yacc, as both of them are the basic tools for cooking the whole project**. As for how to achieve that, you should search for it in yourself.
2. `git clone https://github.com/Autokaka/refined_c_compiler.git`
3. In termial, input:
   - `make` to compile the compiler. The build files shall be generated “build” directory in your project root directory.
   - `make demo` to compile and run an example file to help you understand how to use this simple compiler.
   - `make clean` to clean the generated files and build files.

## What’s more

1. If you need to know the detailed technique about how the script take effect, you can see all of them in `make_all.sh`, `make_clean.sh` and `make_demo.sh`. Talk is cheap in learning new things, you should always read the code :)
2. Here is the tutorial about how to install lex and yacc: https://www.youtube.com/watch?v=8EO5Y7KhoeU. It is a Youtube link, if you are in a country that cannot access foreign website, please use a VPN first.
