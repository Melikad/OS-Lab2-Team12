int main(int argc, char *argv[])
{
    int child1 = fork();
    if(child1 == 0){
        int child2 = fork();
        if(child2 == 0){
            write(1,"the second child\n", strlen("the second child\n"));
            for(int i = 0 ; i < 2000000000 ; i++){}
            write(1,"Second child exits\n", strlen("Second child exits\n"));
            exit();
            
        }
        write(1,"the first child waiting for Second child\n", strlen("the first child waiting for Second child\n"));
        waitForProcess(child2);
        for(int i = 0 ; i < 2000000000 ; i++){}
        write(1,"First child exits\n", strlen("First child exits\n"));
        exit();
    }
    else{
        write(1,"the parent waiting for first child\n", strlen("the parent waiting for first child\n"));
        waitForProcess(child1);
        write(1,"Parent exits\n", strlen("Parent exits\n"));
        exit();
    }

}