# 連続マッチング(2)
function  lmatch(str, reg,  num)  {
  for ( i in ESTART )  {
    delete ESTART[i]
    delete ELENGTH[i]
    delete EMATCH[i]				# 不要ならコメントに
  }
  while ( match(str, reg) > 0 )  {
    ESTART[++num] = ESTART[num]+RSTART		
    ELENGTH[num] = RLENGTH
    EMATCH[num] = substr(str, RSTART, RLENGTH)
    str = substr(str, RSTART+1)	# 一致列の最初の１文字までを削除
  }
  return  num
}
