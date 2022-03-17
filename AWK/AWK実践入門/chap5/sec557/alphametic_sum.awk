##====================================================================
##
##--------------------------------------------------------------------
##
##====================================================================


##====================================================================
##
##====================================================================

BEGIN  {
    FREE = 0;    # 未使用
    USED = 1;    # 使用済
    RAD = 10;    # 多進法の基数

    Ary = 1;     # 加算の項数
    Wid = 0;     # 最大桁数
}

##====================================================================
##  区切線の無視
##====================================================================

/=/ {
    done = 1;    # 演算項の入力が完了(次は結果項)
    next;
}

##====================================================================
##  加算項と結果項の入力
##====================================================================

{
    if ( done == 0 ) { t = Ary++; } else { t = 0; }   # 演算項か結果項か
    Inp[t][1] == ""; Deg[t] = split($0, Inp[t]);      # 入力順のラベル
    w = Deg[t];                                       # 桁数
    if ( Wid < w ) { Wid = w; }                       # 最大桁数
}

##====================================================================
##
##====================================================================

END  {
    ##----  入力順のラベルから桁位置のラベル
    for ( t = 0; t < Ary; t++ ) {
        for ( k = 0; k < Wid; k++ ) {
            Label[t][k] = Inp[t][Deg[t]-k];    # 各桁のラベル
        }
    }

    ##----  出現する文字種をリストを作成
    len = 0;
    for ( t = 0; t < Ary; t++ ) {
        for ( k = 0; k < Deg[t]; k++ ) {
            x = Label[t][k];
            flag = 0;
            for ( v = 0; v < len; v++ ) {
                if ( Alpha[v] == x ) { flag = 1; }
            }
            if ( flag == 0 ) { Alpha[len++] = x; }
        }
    }

    ##----  文字から添字を逆算
    for ( k = 0; k < len; k++ ) { Rev[Alpha[k]] =  k; }

    ##----  覆面算の解法
    evn = enum_alpha(len, 0);
    printf "個数 : " evn "\n"
}

##====================================================================
##  覆面算のための順列の列挙
##====================================================================

function enum_alpha(len, ct,    evn, k, x) {
    evn = 0;
    ##----  解の候補の生成
    if ( ct == len ) {
        for ( x in Rev ) { Ans[x] = Perm[Rev[x]]; }    # 文字と数字の対応
        if ( ! check_alpha() ) { return 0; }           # 正解か確認
        output_ans(); return 1;                        # 正解なら出力
    }
    ##----  下位節の分岐
    for ( k = 0; k < RAD; k++ ) {
        if ( Dgt[k] == USED ) { continue; }
        ##----  試行列を1つ伸ばす
        Perm[ct++] = k; Dgt[k] = USED;
        ##----  再帰呼出
        evn += enum_alpha(len, ct);
        ##----  試行列を1つ縮める
        ct--; Dgt[k] = FREE;
    }
    return evn;    # 解の個数を返却
}

##====================================================================
##  覆面算の確認の計算
##====================================================================

function check_alpha() {
    ##----  最上位桁は0でない
    for ( t = 0; t < Ary; t++ ) {
        deg = Deg[t]-1;
        idx = Label[t][deg];
        if ( Ans[idx] == 0 ) { return 0; }
    }
    ##----  各項の数値
    Num[0] = horner(Label[0], Deg[0]);
    for ( t = 1; t < Ary; t++ ) {
        Num[t] = horner(Label[t], Deg[t]);
    }
    ##----  結果との等式判定
    sum = 0;
    for ( t = 1; t < Ary; t++ ) {
        sum += Num[t];
    }
    return ( Num[0] == sum );
}

##====================================================================
##  ホーナー法による数字から数値への計算
##====================================================================

function horner(lab, deg,    val, p) {
    val = 0;
    for ( p = 1; p <= deg; p++ ) {
        x = lab[deg-p];
        val *= RAD; val += Ans[x];
    }
    return val;
}

##====================================================================
##  覆面算の解の表示
##====================================================================

function output_ans() {
    print "Answer: "
    ##----  加算項の表示
    for ( t = 1; t < Ary; t++ ) {
        for ( k = Wid-1; k >= 0; k-- ) {
            if ( k >= Deg[t] ) { printf "  "; continue;  }
            printf " " Ans[Label[t][k]]
        }
        print ""
    }
    ##----  区切線の表示
    for ( k = 0; k < Wid; k++ ) {
        printf "=="
    }
    print ""
    ##----  結果項の表示
    for ( k = Wid-1; k >= 0; k-- ) {
        if ( k >= Deg[0] ) { printf "  "; continue;  }
        printf " " Ans[Label[0][k]]
    }
    print ""
}
