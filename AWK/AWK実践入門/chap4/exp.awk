# exp.awk	[4.3節]

# 数式への代入
function  subst(fun, val, deg,   ret)  {
  if ( deg == "" )  {			# 次数が無指定の場合
    deg = -1
    while ( fun[deg+1] != "" )  deg++
  }
  do  { ret = ret*val+fun[deg] }  while ( --deg >= 0 )  
  return  ret
}

# 定数倍
function  scalar(f, num, g, deg,   i)  {
  if ( deg == "" )  {			# 次数が無指定の場合
    deg = -1
    while ( f[deg+1] != "" )  { g[deg] = f[++deg]*num }
    while ( g[deg] == 0 && deg > 0 )  { delete g[deg]; deg-- } 		
  }  else  for ( i = 0; i <= deg; i++ )  g[i] = f[i]*num
  return deg
}

# 数式の加法
function  expadd(f1, f2, g, deg,  i)  {
  if ( deg == "" )  {			# 次数が無指定の場合
    deg = -1
    while ( f1[deg+1] != "" || f2[deg+1] != "" )  { 
      deg++; g[deg] = f1[deg]+f2[deg]
    }
    while ( g[deg] == 0 && deg > 0 )   { delete g[deg]; deg-- }
  }  else  for ( i = 0; i <= deg; i++ )  g[i] = f1[i]+f2[i]
  return deg
}

# 数式の乗法
function  expmulti(f1, f2, g, deg,  i, j)  {
  for ( i = 0; i <= deg*2; i++ )  {		# gは2*deg次以下
    for ( j = 0; j <= i; j++ )			
      if ( i-j <= deg )  g[i] += f1[j]*f2[i-j]
  }
  while ( g[i] == 0 && i > 0 )  { delete g[j]; i-- }
  return i
}

