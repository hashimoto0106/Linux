# 桁数を揃えて表示
BEGIN  {  
  n = option(60)+0	# デフォルトで60桁
  tab = "        "	# タブから空白への変換を設定
}

{ 
  gsub(/\t/, tab, $0)
  bf = bf $0
  while ( length(bf) > n )  {
    print  substr(bf, 1, n)
    bf = substr(bf, n+1)
  }
}

END {
  print bf
}
