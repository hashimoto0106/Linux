# 10進数の変換出力
BEGIN  { ind = option() }

ind == "x"  {
  for ( i = 1; i <= NF; i++ )  printf("%x ", $i)
  print ""
}

ind == "o"  {
  for ( i = 1; i <= NF; i++ )  printf("%o ", $i)
  print ""
}
