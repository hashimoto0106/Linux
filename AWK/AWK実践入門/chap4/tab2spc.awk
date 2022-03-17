# タブから空白への変換
BEGIN {
  tabstop = option(8)+0
  if ( tabstop < 1 )  tabstop = 8   # 不正な値ならタブストップは8にする
  space[1] = " "
  for ( i = 2; i <= tabstop; i++ )  # n個のスペースを出力スムースに
    space[i] = " " space[i-1]       # 出力するための配列
}

{
  l = length($0)
  vpos = 0
  for ( pos = 1; pos <= l; pos++ ) {
    c = substr($0, pos, 1)
    if ( c == "\t" ) {
      printf("%s",space[tabstop - vpos % tabstop])
      vpos += tabstop - vpos % tabstop
    }  else  {
      printf("%s", c)
      vpos++
    }
  }
  printf("\n")
}
