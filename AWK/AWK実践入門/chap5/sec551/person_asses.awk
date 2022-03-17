##====================================================================
##
##====================================================================

BEGIN {
    ##----  性格診断のルールのファイルからの読込み
    FS = ",";
    fname = "person_asses.txt"
    while ( (getline < fname) > 0 ) {
        qu[$1] = $2;    # 質問
        ys[$1] = $3;    # 肯定先ノード
        no[$1] = $4;    # 否定先ノード
    }

    ##----  コマンドラインからの入力による性格診断の実行
    print "性格診断"
    print "y: Yes  /  n: No";
    pos = "start";    # 開始ノード
    while ( ys[pos] ) {
        print qu[pos], "?";
        getline ans;
        if ( ans == "y" ) { pos = ys[pos]; } else { pos = no[pos]; }
    }
    print qu[pos], "!";
}
