# フィールドを転置して格納
{
  COL = NR
  if  ( LINE+0 < NF )  LINE = NF
  for  ( i = 1; i <= LINE; i++ )  {
    FLD[i, COL] = $i
    if  ( WID[NR]+0 < length($i) )  WID[NR] = length($i)
  }
}
