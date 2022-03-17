# degree.awk	[5.1節]


# マッチする部分列の出現回数
BEGIN  {
  IGNORECASE = option(0)+0
  getline reg < "/dev/stdin"    # UNIX上なら "/dev/tty"
}

{
  if ( IGNORECASE == 0 )  { str = $0 }  else { str = tolower($0) }
  while ( match(str, reg) > 0 )  {
    arr[substr(str, RSTART, RLENGTH)]++
    str = substr(str, RSTART+1)
    }
}

END  {
  for (i in arr) printf("%3d  %s\n", arr[i], i)
}


##### 参照関数 #####

# option()  [4.4節]  option.awk
function  option(opt)  {
  if (ARGC > 1 && ARGV[1] ~ /^\+.*$/)  {  # オプション指定のチェック
    opt = substr(ARGV[1], 2)     # 先頭の"+"を取り除く
    delete ARGV[1]        # 配列を解放する
  }
  return opt
}
