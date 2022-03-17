# 8進数の変換出力
BEGIN  { ind = option() }

ind == "d"  {
  for ( i = 1; i <= NF; i++ )  printf("%d ", oct($i))
  print ""
}

ind == "x"  {
  for ( i = 1; i <= NF; i++ )  printf("%x ", oct($i))
  print ""
}

function  oct(o,  c, i)  {
  for ( c = length(o); c > 0; c-- )
    i += substr(o, c, 1)*8^(length(o)-c)
  return i
}
