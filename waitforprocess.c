#include "types.h"
#include "stat.h"
#include "user.h"


int 
main(int argc, char *argv[])
{
    int child1,child2;
    child1 = fork();
    if(child1 < 0){
        exit();
    }
    else if(child1 == 0){
            printf(0,"the child1 loop started\n");
            sleep(100);
            printf(0,"the child1 loop ended\n");
            exit();
            
        }
    else{
        child2 = fork();
        if(child2 < 0)
            exit();
        else if(child2 == 0){
            printf(0,"child2 waiting\n");
            waitforprocess(child2);
            printf(0,"child2 returned\n");
        }
        else{
            wait();
        }
    }
    wait();
    exit();

}
    


/*




the child1  ch il   d2 wai ting





*/