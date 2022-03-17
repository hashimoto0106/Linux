# 最左最短マッチング
function  fmatch(str, reg,   len)  {
  FSTART = match(str, reg)
  if ( RLENGTH > 0 )  {
    len = 1
    while ( match(substr(str, 1, len), reg) == 0 ) len++    
    FLENGTH = len
  }  else  { FLENGTH = RLENGTH }
  return FSTART  
}
