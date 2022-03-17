# par0.awk 	[4.9節]



# 関数par()の入出力スクリプト
{
    num = par($0)
    printf("line%3d:%3d <- %s\n", NR, num, $0)
    print "ESTART  ELENGTH ELEVEL  EMATCH"
    if ( ! num )  print " 0       0       0      "
    for  ( i = 1; i <= num; i++ )  {
        printf("%2d%8d%8d", ESTART[i], ELENGTH[i], ELEVEL[i])
        printf("      %s\n", EMATCH[i])
    }
}
