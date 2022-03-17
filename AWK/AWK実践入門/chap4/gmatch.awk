# 連続マッチング(1)
function  gmatch(str, reg,  num, len, i)  {
  for ( i in ESTART )  {
    delete ESTART[i]
    delete ELENGTH[i]
    delete EMATCH[i]			# 不要ならコメントに
  }	
  while ( match(str, reg) > 0 )  {
    len += RSTART			# 相対位置を絶対位置に換算
    ESTART[++num] = len
    ELENGTH[num] = RLENGTH
    EMATCH[num] = substr(str, RSTART, RLENGTH)  # 不要ならコメントに
    str = substr(str, RSTART+RLENGTH) 	# 一致列までの部分を削除
    len += RLENGTH-1			# 削除した部分列の長さを加算
  }
  return  num
}
