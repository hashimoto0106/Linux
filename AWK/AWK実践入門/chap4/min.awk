# 最小値
BEGIN  { n = 0 }
{ if ( min == "" ) min = $n; if ( min+0 > $n+0 ) min = $n; }
END  { print min }
