##====================================================================
##
##====================================================================

##====  暗号表の作成
BEGIN  {
    upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    lower = "abcdefghijklmnopqrstuvwxyz"
    irand(26, list)
}

##====  単純置換型の暗号化
{
    $0 = tolower($0)    # 小文字に統一
    gsub(/[^a-z]/, "", $0)    # 英字以外は削除
    for ( k = 1; k <= 26; k++ )  {
        gsub(substr(lower, k, 1), substr(upper, list[k], 1), $0)
    }
    print
}

##====  ランダム整数列
function  irand(num, arr,   i, key) {
    for ( i=1; i<= num; i++ )  arr[i] = 0    # 配列の初期化
    srand()        # 乱数の種の変更
    do {
        i = 1
        key = int(rand()*num)+1    # ランダム整数
        while ( key > 0 )  if ( arr[i++] == 0 )  key--    # 配列チェック
        arr[--i] = num    # 乱数の格納
    }  while ( --num > 0 )
}
