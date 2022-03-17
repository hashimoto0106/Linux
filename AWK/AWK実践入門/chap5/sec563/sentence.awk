# sentence.awk    [5.4節]


# 文の検出
BEGIN  {
    mes = option("sentence.tmp")
    Q = "\"[^\"]*\""    # 引用文
    reg = "([A-Z]|" Q ")([^.!?\"]|" Q ",)*([.!?]|" Q ") |" Q " "
}                       # 引用を含まない文で十分なときは reg = "[A-Z0-9][^.!?]*[.!?]" でよい

{
    if ( str ~ /^ *$/ )  { ln = NR; pos = 1; str = "" }
    res = length(str)
    str = str $0 " "                                        # バッファに代入
    while ( match(str, reg) > 0 )  {                        # 文のマッチング
        printf("%3d: %2d - ", ln, pos+RSTART-1) > mes       # 位置表示
        if ( ln < NR )  {
            ln = NR                                         # 行番号の更新
            pos = RSTART+RLENGTH-res                        # 相対位置の補正
        }  else  pos += RSTART+RLENGTH-1                    # 相対位置の補正
        printf("%3d: %2d > ", NR, pos-2) > mes              # 位置表示
        printf("%s\n", substr(str, RSTART, RLENGTH)) > mes  # 文の表示
        printf("%s\n", substr(str, RSTART, RLENGTH))        # 文の表示
        str = substr(str, RSTART+RLENGTH)                   # バッファから削除
    }
}


##### 参照関数 ######

# option()    オプション引数の読込み[4.4節]
function  option(opt)  {
    if (ARGC > 1 && ARGV[1] ~ /^\+.*$/)  {  # オプション指定のチェック
        opt = substr(ARGV[1], 2)            # 先頭の"+"を取り除く
        delete ARGV[1]                      # 配列を解放する
    }
    return opt
}
