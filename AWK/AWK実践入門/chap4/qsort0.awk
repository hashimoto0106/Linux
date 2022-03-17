# クイックソートの入出力スクリプト
{ ARR[NR] = $0 }

END {
  qsort(ARR, 1, NR)
  for ( i = 1; i <= NR; i++ )  print ARR[i]
}
