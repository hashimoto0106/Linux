# option.awk	[4.4節]

# オプション引数の読込み
function  option(opt)  {		
  if (ARGC > 1 && ARGV[1] ~ /^\+.*$/)  {  # オプション指定のチェック
    opt = substr(ARGV[1], 2)		  # 先頭の"+"を取り除く
    delete ARGV[1]			  # 配列を解放する
  }
  return opt
}
