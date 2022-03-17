# exchange.awk	[4.2節]
#

# 文字の置換(1)
function  exch1(str, old, new, i)  {
  for ( i = 1; i <= length(old); i++ )    	# oldの長さで繰返し
    gsub(substr(old, i, 1), substr(new, i, 1), str)
  return str
}

# 文字の置換(2)
function  exch2(str, old, new, i, char, po, ret)  {  
  for ( i = 1; i <= length(str); i++ )  {    	# strの長さで繰返し
    char = substr(str, i, 1)
    po = index(old, char)
    if ( po == 0 )  ret = ret char	      	# そのまま連結
    else  ret = ret substr(new, po, 1)	      	# 置換して連結
  }
  return ret
}
