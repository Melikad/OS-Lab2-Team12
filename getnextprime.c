#include "types.h"
#include "stat.h"
#include "user.h"

int main (int argc, char *argv[]) {

    if(argc!=2){
        printf(2, "enter one number\n");
        exit();
    }
    else{
        int num=atoi(argv[1]);
        int prev=0;

        asm volatile(
            "movl %%ebx, %0;"
            "movl %1, %%ebx"
            : "=r" (prev)
            : "r" (num)
        );
        
        // int saved_ebx;
        // int number = atoi(argv[1]);

        //asm(
            //"movl %0, %%ebx" : : "r"(saved_ebx)
            // "movl %%ebx, %0"
            // "movl %1, %%ebx"
            // : "=r" (saved_ebx)
            // : "r" (number)
        //);
        printf(1, "Note: first bigger prime number is %d\n", getnextprime());
        asm("movl %0, %%ebx" : : "r"(prev));
        exit();
    }
}