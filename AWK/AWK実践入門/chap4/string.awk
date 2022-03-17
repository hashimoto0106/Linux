# string.awk	[4.2節]
# 

# 文字列の挿入
function  insert(str, pos, ins)  {
  return substr(str, 1, pos) ins substr(str, pos+1)
}

# 文字列の削除
function  erase(str, pos, len)  {
  return substr(str, 1, pos-1) substr(str, pos+len)
}

# 文字列の繰返し
function  repeat(str, time, i, ret)  {
  for  ( i = 1; i <= time; i++ )  ret = str ret 
  return ret
}

# 文字列の裏返し
function  reverse(str, i, ret)  {
  for  ( i = 1; i <= length(str); i++ )  ret = substr(str, i, 1) ret
  return ret
}

