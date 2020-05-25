make clean
echo "\033[33m/////////////////////////////\033[0m"
echo "\033[33m/////   Compiling...    /////\033[0m"
echo "\033[33m/////////////////////////////\033[0m"
echo "\033[34mRunning yacc build...\033[0m"
yacc -d ./lib/c.y
echo "\033[34mRunning lex build..."
lex ./lib/c.l
echo "\033[34mRedirecting generated yacc files...\033[0m"
mv y.tab.h ./generated/
mv y.tab.c ./generated/
echo "\033[34mRedirecting generated lex files...\033[0m"
mv lex.yy.c ./generated/
echo "\033[34mGCC compiling...\033[0m"
gcc ./generated/lex.yy.c ./generated/y.tab.c -o runner
echo "\033[34mRedirecting build files...\033[0m"
mv ./runner ./build/
