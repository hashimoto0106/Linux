BEGIN  {
  n = option()+0
  irand(n, seq)
  for ( i = 1; i <= n; i++ )  printf " " seq[i]
  print ""
}

##### 参照関数 #####
# option()	[4.4節]	option.awk
function  option(opt)  {		
  if (ARGC > 1 && ARGV[1] ~ /^\+.*$/)  {  # オプション指定のチェック
    opt = substr(ARGV[1], 2)		  # 先頭の"+"を取り除く
    delete ARGV[1]			  # 配列を解放する
  }
  return opt
}

