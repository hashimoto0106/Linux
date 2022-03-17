# 最大値
BEGIN  { n = 0 }
{ if ( max == "" ) max = $n; if ( max+0 < $n+0 ) max = $n; }
END  { print max }
