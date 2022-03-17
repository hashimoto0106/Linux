# tail.awk	[4.5節]


# ファイルの末尾部分
BEGIN  { n = option() }

{ tail[NR] = $0; delete tail[NR-n] }

END  { for ( i = NR-n+1; i <= NR; i++ )  print tail[i] }


##### 参照関数 #####

# option()	[4.4節]  option.awk
function  option(opt)  {		
  if (ARGC > 1 && ARGV[1] ~ /^\+.*$/)  {  # オプション指定のチェック
    opt = substr(ARGV[1], 2)		  # 先頭の"+"を取り除く
    delete ARGV[1]			  # 配列を解放する
  }
  return opt
}
