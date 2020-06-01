make
echo "\033[33m//////////////////////////////////////\033[0m"
echo "\033[33m/////   Running failed demo...   /////\033[0m"
echo "\033[33m//////////////////////////////////////\033[0m"
./build/runner < ./example/failed_demo
echo "\033[33m////////////////////////////////////////\033[0m"
echo "\033[33m/////   Running accepted demo...   /////\033[0m"
echo "\033[33m////////////////////////////////////////\033[0m"
./build/runner < ./example/accepted_demo
