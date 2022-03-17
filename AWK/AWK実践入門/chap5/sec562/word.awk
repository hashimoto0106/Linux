# word.awk    [5.4節]


# 単語の検索
BEGIN  {
    opt = option(":")               # 色指定と位置情報ファイルの設定
    split(opt, arr, ":")            # 引数の分割
    if ( arr[1] != "" )  { clr = arr[1] }  else { clr = "0" }
    if ( arr[2] != "" )  { mes = arr[2] }  else { mes = "word.tmp" }
    getline reg < "/dev/stdin"      # UNIX上なら "/dev/tty"
#  getline new < "/dev/stdin"       # 単語の置換用の入力
    reg = regword(reg)
}

{
    str = " " $0 " "                                  # 各行の前後に空白を挿入
    if ( match(str, reg) > 0 )  {                     # マッチする行かどうか
        pos = 0                                       # 行毎の初期化
        do {
            pos += RSTART                             # 相対位置から絶対位置
            word = substr(str, RSTART+1,RLENGTH-2)    # マッチする文字列の切り出し
            printf("%3d: %2d-%2d; %s\n", NR, pos, pos+RLENGTH-3, word) > mes
            printf("%s", substr(str, 1, RSTART))      # その他の部分は普通に表示
            printf("\033[" clr "m%s\033[0m", word)    # 単語の強調表示
            #printf(new)                              # 単語の置換用(上の行と差し替え)
            str = substr(str, RSTART+RLENGTH-1)       # マッチした列の削除
            pos += RLENGTH-2                          # 区切り文字でのずれの修正
        }  while( match(str, reg) > 0 )
        printf("%s\n", substr(str, 1, length(str)-1)) # 残りの部分の表示
    }  else { print $0 }                              # マッチしない行の表示
}


###### 関数定義 #####

# 単語の正規表現式
function  regword(reg)  {
    gsub(/^ +| +$/, "", reg)                # 前後の空白の削除
    gsub(/ +/, " +", reg)                   # 空白の連続に対処
    gsub(/_/, "[A-Za-z0-9'-]", reg)         # 単語中の１文字
    return "[^A-Za-z'-]" reg "[^A-Za-z'-]"  # 単語の区切り
}


###### 参照関数 #####

# option()    [4.4節]      option.awk
function  option(opt)  {
    if (ARGC > 1 && ARGV[1] ~ /^\+.*$/)  {  # オプション指定のチェック
        opt = substr(ARGV[1], 2)            # 先頭の"+"を取り除く
        delete ARGV[1]                      # 配列を解放する
    }
    return opt
}
