# ed.awk    [5.9節]


# １行エディタ
BEGIN  {
# 一時ファイル名
    TMP[1] = maketmp()                    # ソース
    TMP[2] = maketmp()                    # データ
    TMP[3] = maketmp()                    # 実行結果
# 実行メッセージ
    MES[0] = "   : OPEN; text area "      # 起動時のファイル読み込み
    MES[1] = "   : DONE; "                # 編集コマンド
    MES[2] = "   : SET; "                 # 環境設定コマンド
    MES[3] = "   : CALL; "
    MES[4] = "   : GOOD BYE"
# エラーメッセージ
    ERR[1] = "   : UNMATCH; line number"  # 行番号エラー
    ERR[2] = "   : UNMATCH; command"      # コマンド名エラー
    ERR[3] = "   : UNMATCH; argument"     # 引数エラー
    ERR[4] = "   : UNMATCH; file name"    # ファイル名エラー
# 環境の初期設定
    TABN = 8                              # タブストップの大きさ
    AWK = "gawk "                         # 外部処理のためのawk起動形式
    KEY = ".*"                            # 検索パターン(すべての行にマッチ)
    POS = "^.*$"                          # 置換パターン(行全体にマッチ)
    CLR = 0                               # テキストデータ表示色
    BP = 0                                # エラービープ音(なし)
    CUR = MARK = LAST = AGO = 0           # 行指定
# 入力ファイル無指定の場合
    if ( ARGC == 1 )  exit
}

FNR == 1  {
    if ( NR != 1 )  print MES[0] fst "-" NR-1 " for " FILE
    fst = NR; FILE = FILENAME
}

{ NEW[NR] = OLD[NR] = $0 }

END  {
    if ( NR == 0 )  { print MES[0] "EMPTY" }
    else { CUR = 1; LAST = AGO = NR; print MES[0] fst "-" LAST "  for " FILE }
    ed_command(CUR)                                           # 初期カレント行表示
    for ( ; ; )  {                                            # メインループ
        getline message < "/dev/stdin"                        # コマンド入力
        ed_input(message, para)                               # コマンド解析
        para[4] = ed_command(para[1], para[2], para[3])       # コマンド実行
        if ( para[4] > 0 )  { COM = para[2]; ARG = para[3] }  # コマンド記録
    }
}

# コマンド入力の解析
function  ed_input(mes, arr)  {
    arr[1] = substr(mes, 1, index(mes, ":")-1)                # 行指定
    if ( sub(/^[^:]*:[ \t]*/, "", mes) == 0 )  mes = ""       # コマンド名以前を削除
    match(mes, /[^ \t]+/)                                     # コマンド名の区切り
    arr[2] = substr(mes, 1, RLENGTH)                          # コマンド名
    arr[3] = substr(mes, RLENGTH+2)                           # 引数部分
}

# 行指定の換算
function  ed_line(num, def, po,  top)  {
    gsub(/[ \t]/, "", num)                                  # 行指定の整形
    if ( po == "" )  { po = CUR; top = 1 }                  # 基準行の設定
    if ( num == "" )  num = def                             # デフォルト指定
# 直接指定
    if ( num ~ /^[0-9]+$/ )  return num+0                   # 行番号
# 基準行からの間接指定
    if ( num ~ /^[Cc]$/ )  return po                        # 基準行
    if ( num ~ /^[Nn]$/ )  return po+1                      # 直後の行
    if ( num ~ /^[Pp]$/ )  return po-1                      # 直前の行
    if ( num ~ /^[Ff]$/ )  return ed_search(po, 1)          # 前向き検索
    if ( num ~ /^[Bb]$/ )  return ed_search(po, -1)         # 後向き検索
# 環境変数による行指定
    if ( num ~ /^[Mm]$/ )  return MARK                      # マーク行
    if ( num ~ /^[Ee]$/ )  return LAST                      # 最後の行
    if ( num ~ /^[Aa]$/ )  return AGO                       # 旧エリアの最後の行
# テキストエリアの更新を伴う行指定
    if ( num ~ /^[Ii]$/ && top = 1 )  return ed_insert(po)  # 基準行への挿入行
    if ( num ~ /^[Oo]$/ && top = 1 )  return ed_insert(0)   # 最初への挿入行
    if ( num ~ /^[Xx]$/ && top = 1 )  return ++LAST         # 最後への挿入行
    return -1                          # 該当行なし
}

# コマンドの解釈
function  ed_command(num, com, arg)  {
    num = ed_line(num, "C")                           # 行指定の換算
    if ( num >= 0 && num <= LAST )  CUR = num         # カレント行の更新
    else  return com_echo(CUR, -1)                    # 行指定エラー
# テキスト表示コマンド
    if ( com == "" )                 return com_echo(num)
    if ( com == ":" )                return com_view(num, "", arg)
    if ( com ~ /^ct\+?$/ )           return com_count(num, com)
# 環境変数設定コマンド
    if ( com == "mark" )             return com_mark(num)
    if ( com ~ /^o?fs$/ )            return com_fs(num, com, arg)
    if ( com == "reg" )              return com_reg(num, "", arg)
    if ( com == "key" )              return com_key(num, "", arg)
    if ( com == "pos" )              return com_pos(num, "", arg)
    if ( com == "file" )             return com_file(num, "", arg)
    if ( com ~ /^lib-?$/ )           return com_lib(num, com, arg)
    if ( com == "clr" )              return com_clr(num, "", arg)
    if ( com ~ /^bp-?$/ )            return com_beep(num, com)
# 基本編集コマンド
    if ( com == ";" )                return com_new(num, "", arg)
    if ( com == "copy" )             return com_copy(num, "", arg)
    if ( com ~ /^\$.+;$/ )           return com_exfld(num, com, arg)
    if ( com ~ /^\$.+\+$/ )          return com_infld(num, com, arg)
    if ( com ~ /^%.+;$/ )            return com_expos(num, com, arg)
    if ( com ~ /^%.+\+$/ )           return com_inpos(num, com, arg)
    if ( com ~ /^ex\+?/ )            return com_exreg(num, com, arg)
    if ( com == "shft" && num > 0 )  return com_shft(num, "", arg)
    if ( com == "kill" && num > 0 )  return com_kill(num, "", arg)
# 外部処理の起動コマンド
    if ( com ~ /^do\+?$/ )           return com_do(num, com, arg)
    if ( com ~ /^awk\+?$/ )          return com_awk(num, com, arg)
    if ( com == "call" )             return com_call(num, "", arg)
# ファイルへのアクセス
    if ( com == "load" && num > 0 )  return com_load(num, "", arg)
    if ( com == "save" && num > 0 )  return com_save(num, "", arg)
    if ( com == "read" )             return com_read(num, "", arg)
    if ( com == "wrt" )              return com_wrt(num, "", arg)
# メタコマンド
    if ( com == "?" )                return com_undo(num, "", arg)
    if ( com == "!" )                return com_redo(num, "", arg)
    if ( com == "bye" )              return com_exit()
# コマンド未定義エラー
    return com_echo(CUR, -2)
}

# エラーメッセージの表示
function  ed_error(num)  {
    if ( BP > 0 ) printf "\a"        # エラー発生ビープ
    print ERR[-num]; return num      # エラーメッセージ出力
}

# 正規表現による検索
function  ed_search(num, step)  {
    do  { num += step }                # 前向きか後向きか
    while  ( match(NEW[num], KEY) == 0 && num >= 1 && num <= LAST )
    if ( num < 1 || num > LAST ) { return -1 }  else { return num }
}

# １行挿入処理
function  ed_insert(num,  i)  {
    AGO = LAST++
    for ( i = LAST; i > num; i-- )  { OLD[i] = NEW[i]; NEW[i] = NEW[i-1] }
    NEW[num+1] = ""; return num+1
}


##### テキスト表示コマンド #####

# １行の表示
function  com_echo(num, ret)  {
    if ( ret < 0 )  ed_error(ret)                          # エラーメッセージ出力
    printf("%3d: ", num); printc(NEW[num], CLR); print ""  # カレント行表示
    return ret                                             # コマンド返り値
}

# 範囲の表示
function  com_view(num, com, arg,   i)  {
    arg = ed_line(arg, "E", num)                              # 行指定の換算
    if ( arg < num || arg > LAST )  return com_echo(num, -3)  # 引数エラー
    for ( i = num; i <= arg; i++ )  com_echo(i)               # 行内容の出力
    print MES[1] "view area " num "-" arg; return com_echo(num, 0)
}

# 文字数表示
function  com_count(num, com, arg,  i, j, str, ct, char, len, num1, num2)  {
    str = NEW[num]; ct = length(CLR)-1                      # 色指定によるタブのずれの補正
    for ( i = 1; i <= length(str); i++ ) {
        char = substr(str, i, 1)
        if ( char == "\t" )  { len = TABN-ct%TABN           # タブの大きさの計算
        }  else { len = length(char) }
        if ( com == "ct" )  {                               # 文字単位で表示
            num1 = num1 sprintf("%-" len "s", int(i/10))    # 十の位
            num2 = num2 sprintf("%-" len "s", i%10)         # 一の位
        }  else {                                           # 半角文字単位で表示
            for ( j = ct-length(CLR)+2; j <= ct-length(CLR)+len+1; j++ )  {
                num1 = num1 int(j/10); num2 = num2 j%10     # １文字の大きさ分を埋める
            }
        }
        ct += len                                           # 文字数のカウンタ
    }
    print "   : " num1 "\n   : " num2; return com_echo(num, 0)
}


##### 環境変数設定コマンド #####

# 行番号のマーキング
function  com_mark(num)  {
    MARK = num; print MES[2] "MARK = " num; return com_echo(num, 0)
}

# フィールド分離記号の設定
function  com_fs(num, com, arg)  {
    if ( com == "ofs" )  { OFS = arg; print MES[2] "OFS = " arg }
    if ( com == "fs" )  { FS = arg; print MES[2] "FS = /" arg "/" }
    return com_echo(num, 0)
}

# 検索パターン(正規表現)の設定
function  com_key(num, com, arg)  {
    if ( arg != "" )  KEY = arg
    print MES[2] "KEY = /" KEY "/"; return com_echo(num, 0)
}

# 置換パターン(正規表現)の設定
function  com_pos(num, com, arg)  {
    if ( arg != "" )  POS = arg
    print MES[2] "POS = /" POS "/"; return com_echo(num, 0)
}

# 検索と置換のためのパターン(正規表現)の同時設定
function  com_reg(num, com, arg)  {
    if ( arg != ""  )  KEY = POS = arg
    print MES[2] "KEY = /" KEY "/,  POS = /" POS "/"
    return com_echo(num, 0)
}

# テキストデータの色指定
function  com_clr(num, com, arg)  {
    gsub(/[ \t]/, "", arg)
    if ( arg !~ /[0-9]+;?[0-9]*/ )  return com_echo(num, -3)
    CLR = arg; return com_echo(num, 0)
}

# エラー発生時のビープ音の有無の設定
function  com_beep(num, com)  {
    if ( com == "bp" )  { BP = 1 }  else { BP = 0 }
    return com_echo(num, 0)
}

# 操作ファイルの設定
function  com_file(num, com, arg)  {
    gsub(/[ \t]/, "", arg); if ( arg == "" )  arg = FILE       # 引数省略の場合
    if ( ( getline < arg ) < 0 )  return com_echo(num, -4)     # ファイルの有無
    close(arg); FILE = arg
    print MES[2] "FILE = " FILE; return com_echo(num, 0)       # 実行メッセージ
}

# ライブラリファイルの設定
function  com_lib(num, com, arg,   i)  {
    split(arg, arr, "[ \t]+")                                  # ファイル名のリスト
    if ( com == "lib-" && arr[1] == "" )  LIB = ""             # 初期化
    while ( arr[++i] != "" )  {
        gsub(" -f " regesc(arr[i]), "", LIB)                   # ファイル名の削除
        if ( com == "lib" && ( getline < arr[i] ) >= 0 )  {    # ファイルの有無
            close(arr[i]); LIB = LIB " -f " arr[i]             # ファイル名の追加
        }
    }
    arg = LIB; gsub(/ -f /, " ", arg)                          # ファイル名のリスト
    print MES[2] "LIB = " arg; return com_echo(num, 0)         # 実行メッセージ
}


##### 基本編集コマンド #####

# 行の書換え
function  com_new(num, com, arg)  {
    OLD[num] = NEW[num]; NEW[num] = arg; return com_echo(num, 1)
}

# 行のコピー
function  com_copy(num, com, arg)  {
    arg = ed_line(arg, 0, num)
    if ( arg < 0 || arg > LAST )  return com_echo(num, -3)
    return com_new(num, "", NEW[arg])
}

# 指定位置からの書換え
function  com_expos(num, com, arg,   n, arr)  {
    n = length(com)-2; com = substr(com, 2, n)       # 位置指定の切出し
    split(com, arr, "-")                               # 位置指定を分割
    if ( arr[1] !~ /^[0-9]*$/ || arr[2] !~ /^[0-9]*$/ )  return com_echo(num, -2)
    if ( arr[1] == "" )  arr[1] = 1                    # 始めの位置
    if ( arr[2] == "" )  arr[2] = length(NEW[num])    # 終わりの位置
    OLD[num] = NEW[num]
    NEW[num] = substr(NEW[num], 1, arr[1]-1) arg substr(NEW[num], arr[2]+1)
    return com_echo(num, 1)
}

# 指定位置への挿入
function  com_inpos(num, com, arg)  {
    com = substr(com, 2, length(com)-2)             # 位置指定の切り出し
    if ( com ~ /^[Ee]$/ )  com = length(NEW[num])   # 行の最後の指定
    if ( com !~ /^[0-9]+$/ )  return com_echo(num, -2)
    OLD[num] = NEW[num]
    NEW[num] = substr(NEW[num], 1, com+0) arg substr(NEW[num], com+1)
    return com_echo(num, 1)
}

# フィールドへの代入
function  com_exfld(num, com, arg,   i, n, arr)  {
    com = substr(com, 2, length(com)-2)         # フィールド指定の切出し
    if ( com !~ /^([0-9]+|NF)$/ )  return com_echo(num, -2)
    n = split(NEW[num], arr)                    # フィールドへの分割
    if ( com == "NF" )  com = n                 # "NF"指定の換算
    arr[com+0] = arg;                           # フィールドへの代入
    OLD[num] = NEW[num]; NEW[num] = ""          # 行内容の保存と初期化
    for ( i = 1; i <= n; i++ )  {
        NEW[num] = NEW[num] arr[i]              # フィールドの連結
        if ( i < n )  NEW[num] = NEW[num] OFS   # 最後以外は区切りOFSを付加
    }
    return com_echo(num, 1)
}

# フィールドの挿入
function  com_infld(num, com, arg,   i, n, arr)  {
    com = substr(com, 2, length(com)-2)                # フィールド指定の切出し
    if ( com !~ /^([0-9]+|NF)$/ )  return com_echo(num, -2)
    OLD[num] = NEW[num]; n = split(NEW[num], arr)      # フィールドへの分割
    if ( com == "NF" )  com = n                        # "NF"指定の換算
    OLD[num] = NEW[num]; NEW[num] = ""; com += 0       # 行内容の保存と初期化
    if ( com == 0 )  NEW[num] = arg OFS                # 先頭に挿入
    for ( i = 1; i <= n; i++ )  {
        NEW[num] = NEW[num] arr[i]                     # フィールドの連結
        if ( com == i )  NEW[num] = NEW[num] OFS arg   # フィールドの挿入
        if ( i < n )  NEW[num] = NEW[num] OFS          # 最後以外は区切りOFSを付加
    }
    return com_echo(num, 1)
}

# 正規表現による置換
function  com_exreg(num, com, arg)  {
    OLD[num] = NEW[num]                             # 行内容の保存
    if ( com == "ex" )  sub(POS, arg, NEW[num])     # sub()で１回だけ置換
    if ( com == "ex+" )  gsub(POS, arg, NEW[num])   # gsub()で何回も置換
    return com_echo(num, 1)
}

# awkマクロによる１行編集
function  com_do(num, com, arg,   lib)  {
    if ( com == "do+" )  lib = LIB                      # ライブラリの拡張機能
    print "{ " arg "; print }" > TMP[1]; close(TMP[1])  # ソースファイル
    print NEW[num] > TMP[2]; close(TMP[2])              # データファイル
    arg = AWK lib " -f " TMP[1] " " TMP[2]              # awkの実行形式
    OLD[num] = NEW[num]; arg | getline NEW[num]         # 実行結果の読込み
    close(arg); return com_echo(num, 1)
}


##### 一括編集コマンド #####

# 行番号の繰り下げ(テキストエリアの拡大)
function  com_shft(num, com, arg,  shift, i)  {
    arg = ed_line(arg, "N", num)                            # 指定行の換算
    if ( arg <= num )  return com_echo(num, -3)
    shift = arg-num; AGO = LAST; LAST += shift              # 新しいテキストエリア
    for ( i = LAST; i >= arg; i-- )  { OLD[i] = NEW[i]; NEW[i] = NEW[i-shift] }
    while ( i >= num )  { OLD[i] = NEW[i]; NEW[i--] = "" }  # 空行の挿入
    print MES[1] "insert area " num "-" arg-1 ",  new area 1-" LAST
    return com_echo(num, 2)
}

# 行の削除(テキストエリアの縮小)
function  com_kill(num, com, arg,  shift, i)  {
    arg = ed_line(arg, "C", num)                             # 指定行の換算
    if ( arg < num || arg > LAST )  return com_echo(num, -3)
    shift = arg-num+1; AGO = LAST; LAST -= shift             # 新しいテキストエリア
    for ( i = num; i <= LAST; i++ )  { OLD[i] = NEW[i]; NEW[i] = NEW[i+shift] }
    while ( i <= AGO )  { OLD[i] = NEW[i]; delete NEW[i++] } # 行の削除
    printf MES[1] "kill area " num "-" arg ",  new area "
    if ( LAST == 0 )  { printf "EMPTY \n" }  else { printf "1-" LAST "\n" }
    if ( LAST < num )  num = CUR = LAST
    return com_echo(num, 2)
}

# コマンドとしてのawkの実行
function  com_awk(num, com, arg,   i, lib, flag)  {
    if ( com == "awk+" )  lib = LIB                 # ライブラリの使用
    gsub(/ /, "  ", arg); arg = " " arg " "         # 区切り(空白)の修正
    if ( match(arg, /[ \t]#[ \t]/) > 0 )  {         # "#"のためのファイル作成
        printf "" > TMP[2]; for ( i = 1; i <= LAST; i++ )  print NEW[i] >> TMP[2]
        close(TMP[2])
    }
    if ( gsub(/>[ \t]+#[ \t]/, "> " TMP[3] " ", arg) > 0 )  flag = 1
    gsub(/(^|[ \t])#[ \t]/, " " TMP[2] " ", arg)    # "#"を一時ファイル名に置換
    system(AWK lib arg); close(AWK lib arg)         # 外部処理の起動
    print MES[3] AWK lib arg
    if ( flag == 1 )  { com_load(1, "", " < " TMP[3]);  return 3 }  # ロード
    else  return com_echo(num, 3)
}

# DOS上のコマンドの実行
function  com_call(num, com, arg)  {
    system(arg); close(arg); print MES[3] arg; return com_echo(num, 3)
}


##### ファイルアクセスコマンド #####

# ファイルへの１行出力
function  com_wrt(num, com, arg,   n, fl)  {
    gsub(/[ \t]/, "", arg); n = index(arg, ">")        # リダイレクト記号の検出
    if ( n > 0 )  { fl = substr(arg, n+1); arg = substr(arg, 1, n-1) }
    if ( arg != "" )  return com_echo(num, -3)
    if ( fl == "" )  fl = FILE
    if ( ( getline < fl ) < 0 )  print  NEW[num] > fl  # ファイルの新規作成
    else { close(fl); print NEW[num] >> fl  }          # 既存ファイルへの追加
    close(fl)
    print MES[1] "wrt line " num "  to " fl; return com_echo(num, 1)
}

# ファイルからの１行入力
function  com_read(num, com, arg,   n, fl, mes)  {
    gsub(/[ \t]/, "", arg); n = index(arg, "<")        # リダイレクト記号の検出
    if ( n > 0 )  { fl = substr(arg, n+1); arg = substr(arg, 1, n-1) }
    if ( arg == "" )  arg = 1                          # デフォルトは１行目
    if ( arg !~ /^[0-9]+$/ || arg+0 == 0 )  return com_echo(num, -3)
    if ( fl == "" )  fl = FILE
    if ( ( getline < fl ) < 0 )  return com_echo(num, -4)
    close(fl); mes = AWK " \"NR==" arg "\" " fl        # awkスクリプトの作成
    OLD[num] = NEW[num];  mes | getline NEW[num]; close(mes)
    print MES[1] "read line " arg "  from " fl; return com_echo(num, 1)
}

# ファイルへの書込み
function  com_save(num, com, arg,   n, fl, i)  {
    gsub(/[ \t]/, "", arg); n = index(arg, ">")        # リダイレクト記号の検出
    if ( n > 0 )  { fl = substr(arg, n+1); arg = substr(arg, 1, n-1) }
    arg = ed_line(arg, "E", num)                       # 指定行の換算
    if ( arg < num || arg > LAST )  return com_echo(num, -3)
    if ( fl == "" )  fl = FILE
    printf "" > fl; close(fl)                          # ファイルを空に初期化
    for (i = num; i <= arg; i++ )  { print NEW[i] >> fl }; close(fl)
    print MES[1] "save area " num "-" arg "  to " fl; return com_echo(num, 2)
}

# ファイルからの読込み
function  com_load(num, com, arg,  n, fl, i, res, las)  {
    gsub(/[ \t]/, "", arg); n = index(arg, "<")        # リダイレクト記号の検出
    if ( n > 0 )  { fl = substr(arg, n+1);  arg = substr(arg, 1, n-1) }
    arg = ed_line(arg, 0, num)                         # 指定行の換算(0は仮の値)
    if ( arg != 0 && ( arg < num || arg > LAST ) )  return com_echo(num, -3)
    if ( fl == "" )  fl = FILE
    i = num; if ( ( getline < fl ) < 0 )  return com_echo(num, -4)
    close(fl)
    while ( ( getline res < fl ) > 0 && ( i <= arg ||  arg == 0 ) )  {
        OLD[i] = NEW[i]; NEW[i++] = res                # 指定範囲内でロード(arg=0では最後まで)
    }
    close(fl); las = i-1
    while ( i <= LAST && ( i <= arg || arg == 0 ) )  {
        OLD[i] = NEW[i]; NEW[i++] = ""                 # 指定範囲内で余った部分を空行にする
    }
    if ( arg == 0 )  AGO = LAST; LAST = las            # 新しいテキストエリアの大きさ
    printf MES[1] "load area "
    if ( LAST >= num )  { printf num "-" las "  from " fl ",  new area " }
    else { num = CUR = las; printf "EMPTY  from " fl ",  new area "}
    if ( LAST == 0 )  { print "EMPTY" }  else { print "1-" LAST }
    return com_echo(num, 2)
}


##### メタコマンド #####

# 直前の編集コマンドの再実行
function  com_redo(num, com, arg,   i)  {
    arg = ed_line(arg, "C", num)                                  # 指定行の換算
    if ( arg < num || arg > LAST )  return com_echo(num, -3)
    printf("   : %s %s\n", COM, ARG)                              # 直前の編集コマンドの表示
    if ( arg == num )  { ed_command(num, COM, ARG); return 0 }    # 再実行
    if ( para[4] > 1 )  return  com_echo(num, -3)                 # コマンド返り値のチェック
    for ( i = 1; i <= arg; i++ )  ed_command(i, COM, ARG)         # 繰返し再実行
    print MES[1] " redo area " num "-" arg
    CUR = num; return com_echo(num, 0)
}

# 直前の編集コマンドによる行内容の変更の取り消し(行内容の復元)
function  com_undo(num, com, arg,   i)  {
    arg = ed_line(arg, "C", num)                                    # 指定行の換算
    if ( arg < num || ( arg > AGO && arg > LAST ) )  return com_echo(num, -3)
    if ( arg == num )  { com_new(num, "", OLD[num]); return 0 }     # １行の復元
    for ( i = num; i <= arg; i++ )  com_new(i, "", OLD[i])          # 範囲の復元
    print MES[1] "undo area " num "-" arg
    if ( arg > LAST ) { AGO = LAST; LAST = arg }                    # テキストエリアの大きさ
    return com_echo(num, 0)
}

# エディタ終了
function  com_exit(num, com, arg, i)  {
    print MES[4]; exit
}


##### 参照関数 #####

# printc()    カラー出力
function  printc(str, clr)  {
    printf("\033[" clr "m%s\033[0m", str)
}

# maketmp()    一時ファイル名の作成
function  maketmp()     {
    gsub(/\\/,"/",".")
    return ( "." "/awk" ++TMPNUM )
}

# regesc()    特殊文字のエスケープ
# 特殊文字のエスケープ
function  regesc(str)  {
    gsub(/\\/, "\\\\", str)
    gsub(/\|/, "\\|", str)
    gsub(/\?/, "\\?", str)
    gsub(/\+/, "\\+", str)
    gsub(/\*/, "\\*", str)
    gsub(/\$/, "\\$", str)
    gsub(/\^/, "\\^", str)
    gsub(/\./, "\\.", str)
    gsub(/\(/, "\\(", str)
    gsub(/\)/, "\\)", str)
    gsub(/\[/, "\\[", str)
    gsub(/\]/, "\\]", str)
    return str
}
