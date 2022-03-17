# tfld.awk	[4.5節]


# フィールドを転置して格納
{
    COL = NR
    if  ( LINE < NF )  LINE = NF
    for  ( i = 1; i <= LINE; i++ )  {
        FLD[i, COL] = $i
        if  ( WID[NR] < length($i) )  WID[NR] = length($i)
    }
}
