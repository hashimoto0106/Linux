# par.awk     [4.9節]
#


# 括弧の対応
function  par(str,   left, right, reg, num, i, lev, pos)  {
    left = "("                       # 左区切り
    right = ")"                      # 右区切り
    reg = "\\(|\\)"                  # 検索用の正規表現式
    for (i in ESTART)  {
        delete ESTART[i]
        delete ELENGTH[i]
        delete ELEVEL[i]
        delete EMATCH[i]
    }
    while ( match(str, reg) > 0 )  {             # 括弧の検索
        pos += RSTART                            # 絶対位置への換算
        if ( substr(str, RSTART, 1) == left )  { # 部分列の始まり
            ESTART[++num] = pos
            ELEVEL[num] = ++lev                  # 深さの増加
        }  else  {                               # 部分列の終わり
            lev--                                # 深さの減少
            for ( i = num; ELENGTH[i] > 0 && i > 0 ; i-- )  { }
            ELENGTH[i] = pos+RLENGTH-ESTART[i]
            EMATCH[i] = substr($0, ESTART[i], ELENGTH[i])
        }
        str = substr(str, RSTART+1)              # 検索終了部分の削除
    }
    return num
}
