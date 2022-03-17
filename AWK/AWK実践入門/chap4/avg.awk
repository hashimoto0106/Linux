# 平均値
BEGIN  { n = 0 }
{ total += $n }
END  { print total/NR }
