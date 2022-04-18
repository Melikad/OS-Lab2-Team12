#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char *argv[]) 
{
    
    printf(1, "process having most fork call is: %d\n", getmostcaller(1));
    printf(1, "process having most wait call is: %d\n", getmostcaller(3));
    printf(1, "process having most write call is: %d\n", getmostcaller(16));
    exit();
    
}