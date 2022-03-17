# 16進数の変換出力
BEGIN {
  ind = option()
  for ( i = 0; i < 10; i++ )  HEX[i] = i
  HEX["A"] = 10; HEX["a"] = 10
  HEX["B"] = 11; HEX["b"] = 11
  HEX["C"] = 12; HEX["c"] = 12
  HEX["D"] = 13; HEX["d"] = 13
  HEX["E"] = 14; HEX["e"] = 14
  HEX["F"] = 15; HEX["f"] = 15
}

ind == "d"  {
  for ( i = 1; i <= NF; i++ )  printf("%d ", hex($i))
  print ""
}

ind == "o"  {
  for ( i = 1; i <= NF; i++ )  printf("%o ", hex($i))
  print ""
}

# 16進数から10進数への換算
function hex(h,   c, i)  {
  for ( c = length(h); c > 0; c-- )
    i += HEX[substr(h, c, 1)] * 16^(length(h) - c)
  return i
}
