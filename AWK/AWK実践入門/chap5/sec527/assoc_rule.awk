# gawk -f assoc_rule.awk -v feq=3 basket1.txt

##====
BEGIN  {
    FS = ",";
    #freq = 3;    # 度
    #thre = 3;    # 確信度
}

##====  バスケットの入力
{
    basket_line[NR] = csv_sort($0);                  # アイテムを整列して格納
    for ( k = 1; k <= NF; k++ )  item_list[$k]++;    # アイテムの集計
}

##====
END  {
    ##----  バスケットの出力
    num_bsk = NR;    # バスケット数
    PROCINFO["sorted_in"] = "@ind_num_asc";    # 入力順
    for ( bsk in basket_line )
        printf("B: [%2d] %s\n", bsk, basket_line[bsk]);
    print "";

    ##----  アイテムの出力
    PROCINFO["sorted_in"] = "@val_num_desc";    # 頻度順
    for ( itm in item_list )
        print "I: " item_list[itm] "; " itm;
    print "";

    ##---- レベル1の 頻度集合の生成
    set_list[1][""] = "";                                # 配列領域の確保
    PROCINFO["sorted_in"] = "@val_num_desc";             # 頻度順
    for ( itm in item_list )  {                          #
        num_itm++;                                       # アイテム数
        if ( item_list[itm] < freq ) { continue; }       # 閾値で打切り
        set_list[1][itm] = item_list[itm];               # レベル1の頻度集合に追加
        num_lst[1]++;                                    # レベル1の頻度集合の個数
    }
    delete set_list[1][""];

    ##----  頻度集合の生成
    for ( k = 1; k < num_itm; k++ ) {               # レベルごとに処理
        PROCINFO["sorted_in"] = "@val_num_desc";    # 頻度順
        if ( ! isarray(set_list[k]) ) { break; }    # 頻度集合の更新がなくて終了
        for ( ist in set_list[k] ) {                # レベルkの頻度集合について
            for ( itm in set_list[1] ) {            # 閾値以上の頻度のアイテムについて
                if ( ist ~ itm ) { continue; }      # アイテムがリストに存在するか(！)
                csv = csv_sort(ist, +1, itm);       # リストにアイテムを連結
                tmp = ct_occur(csv);                # バスケットでのリストの出現回数
                if ( tmp < freq ) { continue; }     # 閾値で打切り
                set_list[k+1][csv] = tmp;           # レベルk+1の頻度集合に追加
                num_lst[k+1]++;                     # レベルk+1の頻度集合の個数
            }
        }
    }

    ##----  閾値以上の頻度集合の出力
    PROCINFO["sorted_in"] = "@val_num_desc";
    for ( k = 2; k < num_lst[k]; k++ ) {
        for ( ist in set_list[k] )
            print "S: " set_list[k][ist] ": " ist;
    }
    print "";

    ##----  相関ルールの生成と出力
    for ( k = 2; k < num_lst[k]; k++ ) {
        for ( ist in set_list[k] ) {
            deg = set_list[k][ist];
            if ( deg == 0 ) { continue; }
            split(ist, arr, ",");
            for ( k in arr ) {
                csv = csv_sort(ist, -1, arr[k]);
                tmp = ct_occur(csv);
                if ( deg/tmp < thre ) { continue; }
                rule[p++] = sprintf("%.3f : %s <= %s", deg/tmp, arr[k], csv);
            }
        }
    }
    PROCINFO["sorted_in"] = "@val_num_desc";
    for ( p in rule )  print rule[p];
}

##----  アイテムリストのバスケットへの出現回数
function ct_occur(csv,   bsk, item, ct, arr, k, n, flag) {
    ct = 0;
    for ( k in basket_line ) {
        bsk = basket_line[k];
        n = split(csv, arr, ",");
        flag = 1;
        for ( k = 1; k <= n; k++ )
            if ( bsk !~ arr[k] ) { flag = 0; break; }
        if ( flag == 1 ) { ct++; }
    }
    return ct;
}

##====  CSV形式の集合の正規化(要素の整列)
function csv_sort(str, sw, elm,   res, arr, n, k, e) {
    ##----  要素の追加
    if ( sw == +1 )  if ( str !~ elm )  str = str "," elm;
    ##----  要素の削除
    if ( sw == -1 )  sub(elm, "", str);
    ##----  要素の整列
    n = split(str, arr, ",");                  # 配列への分割
    PROCINFO["sorted_in"] = "@val_str_asc";    # 文字列としての昇順
    res = "";                                  # 空列に初期化
    for ( e in arr ) {
        if ( arr[e] == "" ) { continue; }      # 空列は無視
        res = res "," arr[e];                  # CSV形式に連結
    }
    ##----  CSV形式の整形と出力
    res = substr(res, 2);                      # 末尾の , を除去
    return res;
}
