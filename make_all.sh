make clean
echo "\033[33m/////////////////////////////\033[0m"
echo "\033[33m/////   Compiling...    /////\033[0m"
echo "\033[33m/////////////////////////////\033[0m"
echo "\033[34mRunning yacc build...\033[0m"
bison -d ./lib/c.y
echo "\033[34mRunning lex build...\033[0m"
flex ./lib/c.l
echo "\033[34mRedirecting generated yacc files...\033[0m"
mv c.tab.h ./generated/
mv c.tab.c ./generated/
echo "\033[34mRedirecting generated lex files...\033[0m"
mv lex.yy.c ./generated/
echo "\033[34mGCC compiling...\033[0m"
gcc ./generated/lex.yy.c ./generated/c.tab.c -o runner
echo "\033[34mRedirecting build files...\033[0m"
mv ./runner ./build/
