# out.awk	[4.5節]
# 
# 行の区切りを表の大きさにそろえる場合は、コメントアウトの部分を使用
# ただし、repeat() [4.2節] str.awk も必要


# 列ごとの整形出力
END  {
# 表の大きさ
#  WLN = 0; for ( j = 1; j <= COL; j++ )  WLN += WID[j]
#  WLN += length(OFS)*(COL-1)
# 行の区切り
#  ORS = "¥n" repeat("=", WLN) "¥n"           # 同一文字の連続
#  OXS = "<->"				      # 文字列パターンの例
#  ORS = repeat(OXS, int(WLN/length(OXS))+1)  # パターンの繰返し
#  ORS = "¥n" substr(ORS, 1, WLN) "¥n"	      # パターンの切出し
  for ( i = 1; i <= LINE; i++ )  {
    for ( j = 1; j <= COL; j++ )  {
      printf("%" WID[j] "s", FLD[i, j])
      if ( j < COL )  { printf OFS }  else { printf ORS }
    }
  }
}
