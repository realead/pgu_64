
#include <stdlib.h>
#include <stdio.h>

int main(){
    void * res=malloc(40);
    printf("res=%p\n", res);
    void * res2=malloc(40);
    printf("res2=%p\n", res2);
    free(res);
    res=malloc(40);
    printf("res=%p\n", res);
    
    free(res2);
    free(res);
    
    return 0;
}


