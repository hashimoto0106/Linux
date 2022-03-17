# form.awk    [5.5節]


# 日本語文書整形(1)
BEGIN {
    columns = option();
}

/^\\input[ \t]*/ {  # ファイル挿入処理
    if (buf != "") {
        printf("%s%s\n", indent, buf);
        buf = "";
    }
    gsub(/"/,"",$2);
    indent = "";
    while (getline l < $2 > 0)
        print l;
    next;
}

/^\\newpage[ \t]*$/ {  # 改頁処理
    if (buf != "") {
        printf("%s%s\n", indent, buf);
        buf = "";
    }
    indent = "";
    print "\f";
    next;
}

/^[ \t]*$/ {  # 空行なら、バッファをフラッシュしてインデント状態を初期化
    if (buf != "")
        printf("%s%s\n", indent, buf);
    indent = "";
    printf("\n");
    buf = "";
    next;
}

{ #上のパターン以外の行は全てマッチ
    match($0, "^[ \t]+");
    if (RLENGTH > 0)
        nindent = substr($0, 1, RLENGTH);
    else
        nindent = "";
    if (indent != nindent) {
        if (buf != "")
            printf("%s%s\n", indent, buf);
        indent = nindent;
        buf = "";
    }
    if (RLENGTH > 0)
        buf = buf substr($0, RLENGTH + 1);
    else
        buf = buf $0;
    ilen = length(indent);
    while (length(buf) >= columns - ilen) {
##
        printf("%s", indent);
        j = 0;
        i = 1;
        while (1) {
            c = substr(buf, i, 1);
            if (c ~ /[\t !-~]/)
                j++;
            else
                j += 2;
            if (j > columns - ilen)
                break;
            printf("%s", c);
            i++;
        }
        printf("\n");
        buf = substr(buf, i);
##  日本語を考慮しないなら、次のセットを使えば高速になる!?
#        printf("%s%s\n", indent, substr(buf, 1, columns - ilen));
#        buf = substr(buf, columns - ilen + 1);
    }
}

END {
    printf("%s%s\n", indent, buf);
}


##### 参照関数 #####

# option()     [4.4節]  option.awk
function  option(opt)  {
    if (ARGC > 1 && ARGV[1] ~ /^\+.*$/)  {  # オプション指定のチェック
        opt = substr(ARGV[1], 2)            # 先頭の"+"を取り除く
        delete ARGV[1]                      # 配列を解放する
    }
    return opt
}
