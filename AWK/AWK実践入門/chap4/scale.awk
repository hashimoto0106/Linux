# 行番号と桁番号
BEGIN {
  num = option(60)			# 横軸の長さの指定
  qu = int(num/10)			# 10ずつのまとまりの個数
  re = num%10			        # 残りの長さ
  printf("     ")			# 行番号分の空白
  for ( i = 0; i < qu; i++ )  		# 十の位の表示
    printf("%s%s", repeat(i, 9), i+1)	
  printf("%s\n     ", repeat(i, re))	# 十の位の表示
  for ( i = 1; i <= qu; i++ ) 		# 一の位の表示
    printf("%s", "1234567890")
  printf("%s\n\n", substr("123456789", 1, re))  # 一の位の表示
}

{ printf("%3d: %s\n", NR, $0) }		# 行番号の付加
