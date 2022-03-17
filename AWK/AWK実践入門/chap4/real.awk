# real.awk	[4.3節]

# 四捨五入
function round(r, n)  {
  return int(r*10^(-n-1)+0.5)*10^(n+1)
}
