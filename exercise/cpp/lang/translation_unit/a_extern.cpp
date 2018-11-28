/*

--- extern : b_extern.cpp holds the declaration and initialisation of 'b' ---

--------------------------------------------------
--- b_extern compiled along with a_extern ---


g++ a_extern.cpp b_extern.cpp -o ab_extern.out

./ab_extern.out

--------------------------------------------------
--- b_extern compiled as a library, and then compiled/linked to a_extern ---

 2021  g++ -c b_extern.cpp -o b_extern.o  #  NOTE:  g++   -c    [source file(s)]
-o  [ _object_ output file : _object_ because of -c to compile only]
 2022  ls
 2023  ar rvs libb_extern.a b_extern.o   #  NOTE:   ar [options]   lib[library
name].a    [object file]
 2024  ls
 2025  mkdir ./lib
 2026  mv ./libb_extern.a ./lib/libb_extern.a
 2031  g++ a_extern.cpp -L./lib -lb_extern -o a__b_lib__extern.out  #  NOTE:
g++ [source file(s)]  -L[library folder]  -l[library name, WITHOUT the 'lib',
WITHOUT the '.a']    -o  [linked output file]


*/

#include <iostream>

int a = 3;
int c(40);

extern int b;

int main(int argc, char const *argv[]) {
  std::cout << "a == " << a << " , c== " << c << std::endl;
  std::cout << "b == " << b << std::endl;
  return 0;
}
