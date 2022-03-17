# 集計(2)
BEGIN  {  n = option() }

$0 ~ /^-?[0-9][0-9]*$/  {
  if ( MAX == "" )     MAX = $n
  if ( MIN == "" )     MIN = $n
  if ( MAX+0 < $n+0 )  MAX = $n
  if ( MIN+0 > $n+0 )  MIN = $n
  COUNT++
  TOTAL += $n
}

END  {
  print "max = " max()
  print "min = " min()
  print "count = " count()
  print "avg = " avg()
}

function max()  { return MAX }  

function min()  { return MIN }

function avg()  { return TOTAL/COUNT }

function count()  { return COUNT }
