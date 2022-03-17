##====  回数指定の半乱順列
function qrand_rep(seq, n, c,   p1, p2, k)  {
    arr_init(seq, n);                       # 整順列の生成
    while ( c-- > 0 ) {                     # 指定の回数まで
        p1 = int_rand(n);                   # 交換する位置をランダムに選択
        p2 = int_rand(n);
        arr_swap(seq, p1, p2);              # 指定位置での要素の交換
    }
}

##====  確率指定の半乱順列
function qrand_prob(seq, n, p,   k, t)  {
    arr_init(seq, n);                       # 整順列の生成
    for ( k = 1; k < n; k++ ) {
        if ( rand() < p ) {                 # 指定値の確率で交換を実行
            t = int_rand(k+1);              # 交換する他方の位置をランダムに選択
            arr_swap(seq, t, k);            # 指定位置での要素の交換
        }
    }
}

##====  整乱数の生成
function int_rand(n) {
    return int(rand()*n);    # 0〜n-1まで
}

##====  整順列の生成
function arr_init(seq, n,   k) {
    for ( k = 0; k < n; k++ ) { seq[k] = k; }
}

##====  配列要素の交換
function arr_swap(seq, p1, p2,  t) {
    t = seq[p1]; seq[p1] = seq[p2]; seq[p2] = t;
}
