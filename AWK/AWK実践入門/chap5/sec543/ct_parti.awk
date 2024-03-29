##====================================================================
##
##--------------------------------------------------------------------
##
##====================================================================


##====================================================================
##  本体処理
##====================================================================

##--------------------------------------------------------------------
##  事前処理
##--------------------------------------------------------------------

BEGIN {
    printf "? ? ?  ";
}

##--------------------------------------------------------------------
##  対話入力
##--------------------------------------------------------------------

{
    ##----  引数の入力
    num = $1    # 対象数
    mxn = $2    # 上限数
    len = $3    # 収容数
    ##----  計算と出力
    ct = 0;
    ##----  個数の出力(!! 本文にはない追加)
    print "B: " ct_parti(num, mxn, len) " ; " ct;
    ##----
    printf "? ? ?  ";
}


##====================================================================
##  関数定義
##====================================================================

##--------------------------------------------------------------------
##  正整数の分割数の計算
##--------------------------------------------------------------------

function ct_parti(num, mxn, len,   s) {
    ##----  範囲外
    if ( num < 0 || mxn < 0 || len < 0 )  return 0;
    ##----  初期条件
    if ( num == 0 )  return 1;      # 対象数が0で表し切った
    if ( mxn == 0 )  return 0;      # 上限数が0で使えるものがない
    if ( len == 0 )  return 0;      # 個数が0で使い切ってしまった
    ##----  効率化
    if ( num < len )  len = num;    # 使用数は対象数以下
    if ( num < mxn )  mxn = num;    # 上限数は対象数以下
    if ( mxn == 1 && num == len )  return 1;             # 上限数が1で全て使えば届く
    ##----  記憶の利用
    if ( mem[num,mxn,len] > 0 )  { ct++; return mem[num,mxn,len]; }
    ##----  漸化式(二分岐版)
    s = ct_parti(num, mxn-1, len);                           # 上限数mxnを使わない場合
    if ( num >= mxn ) s += ct_parti(num-mxn, mxn, len-1);    # 上限数mxnを使う場合
    ##----  漸化式(多分岐版)
#    s = 0;
#    for ( t = 0; t <= num; t += mxn ) {
#        s += ct_parti_it(num-t, mxn-1, len-t);
#    }
    ##----  記憶の格納
    mem[num,mxn,len] = s;
    return s;
}
