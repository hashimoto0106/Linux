##====  カレンダー
BEGIN  {
    M[1]=31; M[2]=28; M[3]=31; M[4]=30;  M[5]=31;  M[6]=30;
    M[7]=31; M[8]=31; M[9]=30; M[10]=31; M[11]=30; M[12]=31;
    W[0] = "日"; split("月 火 水 木 金 土", W);

    split(option(), date, ".");
    n = week1(date[1]+0, date[2]+0, date[3]+0);
    if ( date[3] != "" )  print W[n] "曜日"
    else if ( date[2] != "" ) {
        calendar(date[1], date[2], M[date[2]], n);
    }
    else for ( i = 1; i <= 12; i++ ) {
            calendar(date[1], i, M[i], week1(date[1], i, 0));
            print ""
        }
}

##====  曜日コードの算出
function week1(y, m, d,   s) {
    s = 5
    y %= 400
    if ( y == 0 || ( y%4 == 0 && y%100 != 0 )) if  ( M[2] == 28 ) M[2]++
    if ( y > 0 )  s += --y+int(y/4)-int(y/100)+int(y/400)+2
    while  ( m > 1 )  s += M[--m]
    return (s+d)%7
}

##====  カレンダーの作成
function calendar(y, m, d, s,   i) {
    printf("     %d%s %d%s\n", y, "年", m, "月")
    print "日 月 火 水 木 金 土 "
    printf("%s", repeat(" ", ((s+1)%7)*3))
    for ( i = 1; i <= d; i++)  {
        printf("%2d ", i)
        if ( (s+i)%7 == 6 ) print ""
    }
    if ( (s+i)%7 != 0 ) print ""
}


########  参照関数

##----  repeat()      [4.2節]  str.awk
function  repeat(str, time,   ret, i)  {
    for  ( i = 1; i <= time; i++ )  ret = ret str
    return ret
}

##----  option()      [4.4節]  option.awk
function  option(opt)  {
    if ( ARGC > 1 && ARGV[1] ~ /^\+.*$/ )  {  # オプション指定のチェック
        opt = substr(ARGV[1], 2)              # 先頭の"+"を取り除く
        delete ARGV[1]                        # 配列を解放する
    }
    return opt
}
