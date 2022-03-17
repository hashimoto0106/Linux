# reg.awk [4.8節]
#
# regsub()とregcyc()には、regesc()が必要

# 特殊文字のエスケープ
function  regesc(str)  {
  gsub(/\\/, "\\\\", str)
  gsub(/\|/, "\\|", str)
  gsub(/\?/, "\\?", str)
  gsub(/\+/, "\\+", str)
  gsub(/\*/, "\\*", str)
  gsub(/\$/, "\\$", str)
  gsub(/\^/, "\\^", str)
  gsub(/\./, "\\.", str)
  gsub(/\(/, "\\(", str)
  gsub(/\)/, "\\)", str)
  gsub(/\[/, "\\[", str)
  gsub(/\]/, "\\]", str)
  return str
}

# 正規表現式の連結
function  regcon(reg1, reg2)  {
  return "(" reg1 ")(" reg2 ")"
}

# 正規表現式の繰返し
function  regrep(reg, low, high,  ret, i)  {
  reg = "(" reg ")"        # 括弧でくくる
  if ( low > 0 )
    for ( i = 1; i <= low; i++ )  ret = ret reg
  if ( high > low )
    for ( i = 1; i <= high-low; i++ )  ret = ret reg "?"
  return ret
}

# 文字列の先頭部分
function  regsub(str,  ret, i)  {
  ret = regesc(str)
  for ( i = jlength(str)-1; i >= 1; i-- )
    ret = ret "|" regesc(jsubstr(str, 1, i))
  return ret
}

# 文字列の巡回
function  regcyc(str,  ret, i)  {
  ret = regesc(str)
  for ( i = 1; i <= jlength(str)-1; i++ )
    ret = ret "|" regesc(jsubstr(str, i+1) jsubstr(str, 1, i))
  return ret
}
