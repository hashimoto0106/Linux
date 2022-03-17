# replace1.awk	[5.7節]


# 辞書による置換
BEGIN {
    i=0
    while ( ( getline < "dict1.txt" ) > 0 )  {    # dict1.txt は辞書ファイル名
        source[i] = $1
        destination[i] = $2
        i++
    }
}

{
    for ( i in source ) {
        t = sprintf("{@%d@}", i)
        gsub(source[i], t, $0)
    }
    for ( i in destination ) {
        t = sprintf("{@%d@}", i)
        gsub(t, destination[i], $0)
    }
    print $0
}
