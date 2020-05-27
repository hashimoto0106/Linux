#include <stdio.h>
#include <stdlib.h>

/* main */
int main(void) {
    char *echo = "echo snoopy";
    char *ls = "ls -l hoge";

    printf("> echo snoopy\n");
    int ret = system(echo);
    printf("ret = %d\n",ret);
    printf("> ls -l hoge\n");
    system(ls);

    return EXIT_SUCCESS;
}

