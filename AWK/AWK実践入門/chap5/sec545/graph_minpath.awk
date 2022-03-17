##====================================================================
##  有向グラフの隣接行列の算法
##  graph_minpath.awk
##--------------------------------------------------------------------
##
##====================================================================


##====================================================================
##
##====================================================================

##====  点ごとの有向辺のリストからの隣接行列の生成
$0 !~ /^#/ {
    node[$1] = 1;                    # 始点の登録
    for ( k = 2; k <= NF; k++ ) {
        rel[$1][$k] = 1;             # 終点ごとに隣接行列に格納
    }
}

##====  計算と出力
END {
    ##----  隣接行列(!! 本文にはない追加)
    rel_output(rel, node);
    print "";
    ##----  隣接行列の閉包
    rel_copy(tab1, rel, node);
    rel_closure(tab0, tab1, node);
    rel_output(tab0, node);
    print "";
    ##----  隣接行列の最短経路数
    rel_copy(tab1, rel, node);
    rel_minpath(tab0, tab1, node);
    rel_output(tab0, node);
}

##====  隣接行列の出力
function rel_output(tab, lst,     x, y) {
    ##----  ラベルの横軸の出力
    printf " ";
    for ( y in lst ) { printf " " y; }
    print "";
    ##----  ラベルの縦軸と隣接行列の成分の出力
    for ( x in lst ) {
        printf x;
        for ( y in lst ) { printf " " tab[x][y]+0; }
        print "";
    }
}

##====  隣接行列の複写
function rel_copy(tab0, tab1, lst,    x, y) {
    for ( x in lst ) {
        for ( y in lst ) {
            tab0[x][y] = tab1[x][y];
        }
    }
}

##====  離接行列の相等
function rel_equ(tab1, tab2, lst,    x, y) {
    for ( x in lst ) {
        for ( y in lst ) {
            if ( tab1[x][y] != tab2[x][y] ) { return 0; }
        }
    }
    return 1;
}

##====  隣接行列の単位行列化
function rel_idnt(tab, lst,    x) {
    for ( x in lst ) { tab[x][x] = 1; }    # 対角成分を1にする
}

##====  隣接行列の合成
function rel_cmps(tab0, tab1, tab2, lst,    x, y, z) {
    for ( x in lst ) {
        for ( y in lst ) {
            for ( z in lst ) {
                tab0[x][y] += tab1[x][z] * tab2[z][y];
            }
            if ( tab0[x][y] > 0 ) { tab0[x][y] = 1; }
        }
    }
}

##====  隣接行列の推移閉包(ワーシャル法)
function rel_closure(tab0, tab1, lst,    mlt, tmp) {
    rel_idnt(tab1, lst);
    rel_idnt(tab0, lst);
    while ( 1 ) {
        rel_cmps(tmp, tab0, tab1, lst);
        if ( rel_equ(tmp, tab0, lst) ) { break; }
        rel_copy(tab0, tmp, lst);
    }
}

##====  ノード間の最短経路数(フロイド法)
function rel_minpath(tab0, tab1, lst,  n0, n1, n2, tmp) {
    MAX = 10000;    # 辺がない場合の経路数の仮の無限大
    ##----  経路数の行列tab0の初期化
    for ( n1 in lst ) {
        for ( n2 in lst ) {
            if ( n1 == n2 ) { tab0[n1][n2] = 1; continue; }
            tmp = tab1[n1][n2];
            tab0[n1][n2] = tmp;
            if ( tmp == 0 )  tab0[n1][n2] = MAX    # エッジがないときは無限大
        }
    }
    ##----  tab0の最短経路数の計算
    for ( n1 in lst ) {
        for ( n2 in lst ) {
            for ( n0 in lst ) {
                tmp = tab0[n1][n0] + tab0[n0][n2];
                if ( tab0[n1][n2] > tmp )  tab0[n1][n2] = tmp
           }
        }
    }
    ##----  到達不可能な節同士の経路数を0に
    for ( n1 in lst ) {
        for ( n2 in lst ) {
            if ( tab0[n1][n2] == MAX )  tab0[n1][n2] = 0;
        }
    }
}
