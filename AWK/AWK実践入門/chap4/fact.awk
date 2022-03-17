# fact.awk	[4.3節]

# 階乗(1)
function  fact1(n,  ret)  { 
  ret = 1			 # 計算状況の初期値
  while ( n > 0 )  ret *= n--    # 繰返し制御
  return ret
}

# 階乗(2)
function  fact2(n)  {
  if ( n <= 1 )  return 1	 # 関数の初期値
  return n*fact2(n-1)		 # 再帰呼出し
}

