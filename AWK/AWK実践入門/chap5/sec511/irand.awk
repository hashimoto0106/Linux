# irand.awk	[4.3節]


# ランダム整数列
function  irand(num, arr,   i, key){
    for ( i=1; i<= num; i++ )  arr[i] = 0    # 配列の初期化
    srand()         # 乱数の種の変更
    do {
        i = 1
        key = int(rand()*num)+1      # ランダム整数
        while ( key > 0 )  if ( arr[i++] == 0 )  key--  # 配列チェック
        arr[--i] = num       # 乱数の格納
    }  while ( --num > 0 )
}
