# life.awk    [5.5節]


# ライフゲーム
BEGIN {
    column = 10
    line   = 5
    generation = 1

    for (i = 0; i < line; i++) {
        getline;
        for (j = 0; j < column; j++) {
            if (substr($0, j+1, 1) == "O") field[g,i,j] = "O";
            else field[g,i,j] = ".";
            printf("%s",field[g,i,j]);
            if (field[g,i,j] == "O") population++;
        }
        printf("\n");
    }
    printf("+++ GENERATION : %d ,  POPULATION : %d +++\n\n",
           generation, population);
    while (1) {
        generation++;
        population = 0;
        for (i = 0; i < line; i++) {
            for (j = 0; j < column; j++) {
                local_population(i,j);
                if (p < 2 || p > 3) field[!g,i,j] = ".";
                else if (p == 2) field[!g,i,j] = field[g,i,j];
                else if (p == 3) field[!g,i,j] = "O";
                printf("%s",field[!g,i,j]);
                if (field[!g,i,j] == "O") population++;
            }
            printf("\n");
        }
        printf("+++ GENERATION : %d ,  POPULATION : %d +++\n\n",
               generation, population);
        g = !g;
        if (generation % 10 == 0) {
            printf("Would you like to stop this? ");
            getline < "/dev/stdin";        # UNIXなら "/dev/tty"
            if ($0 ~ /^[yY]/) exit (1);
            else printf("\n");
        }
    }
}


##### 関数定義 #####

# 周囲の人口
function local_population(i, j)
{
    p = 0;
    y = i - 1;
    if (y < 0) y = line - 1;
    for (ii = 0; ii < 3; ii++) {
        x =  j - 1;
        if (x < 0) x = column - 1;
        for (jj = 0; jj < 3; jj++) {
            if (field[g,y,x] != "." && (x != j || y != i)) p++;
            x++;
            if (x == column) x = 0;
        }
        y++;
        if (y == line) y = 0;
    }
    return p;
}
