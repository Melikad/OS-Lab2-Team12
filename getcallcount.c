#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char *argv[]) 
{
    if(argc!=2){
        printf(2, "enter one number\n");
        exit();
    }
    
    int syscallid = atoi(argv[1]);
    int child1 = fork();
    int child2 = fork();
    if(child1 < 0){
        exit();
    }
    else if(child2 < 0){
        exit();
    }
    else{
        write(1, "something to write1\n", strlen("something to write1\n"));
        write(1, "something to write2\n", strlen("something to write2\n"));
        //write(0, "something to write1\n", strlen("something to write1\n"));
        //write(0, "something to write2\n", strlen("something to write2\n"));
        printf(1, "%d systemcall was called during process: %d\n", syscallid, getcallcount(syscallid));

        //write(0, "something to write3\n", strlen("something to write3\n"));
        write(1, "something to write3\n", strlen("something to write3\n"));
        printf(1, "%d systemcall was called during process: %d\n", syscallid, getcallcount(syscallid));
        
        exit();
    }
} 