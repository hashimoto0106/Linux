# num.awk	[4.3節]

# 最大公約数
function  gcd(n1, n2,   d)  {
  if ( n1*n2 == 0 )  return 0
  while  ( n2 > 0 )  { d = n2; n2 = n1%n2; n1 = d }
  return d			# dは１ステップ(入れ換える)前のn2の値
}
