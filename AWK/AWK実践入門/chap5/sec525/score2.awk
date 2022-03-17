##====================================================================
##  成績表
##  score2.awk
##====================================================================

##--------------------------------------------------------------------
##  事前処理
##--------------------------------------------------------------------

BEGIN {
    ##----  成績情報
    score_all = "S A B C X";
    score_num = split(score_all, score_list);
    gpa["S"] = 4; gpa["A"] = 3; gpa["B"] = 2; gpa["C"] = 1; gpa["X"] = 0;
    ##----  科目情報
    subj_all = "国語 数学 英語 理科 社会 音楽";
    subj_num = split(subj_all, subj_list);
    ##----  CSV形式への対応
    FS = ",";
}

##--------------------------------------------------------------------
##  本体処理
##--------------------------------------------------------------------

{
    stud_score[$1][$3]++;    # 学生ごとの成績の集計
    subj_score[$2][$3]++;    # 科目ごとの成績の集計
    score[$1][$2] = $3;      # 成績の格納
}

##--------------------------------------------------------------------
##  事後処理
##--------------------------------------------------------------------

END {
    ##--  学生ごとの成績分布
    print "学生ごとの成績分布";
    print "     : " score_all;
    for ( st in score ) {
        printf st " : ";
        for ( k = 1; k <= score_num; k++ ) {    # 添字の範囲に注意
            sc = score_list[k];
            printf stud_score[st][sc]+0 " ";
        }
        print "";
    }
    print "";

    ##--  科目ごとの成績分布
    print "科目ごとの成績分布";
    print "     : " score_all;
    for ( s = 1; s <= subj_num; s++ ) {    # 添字の範囲に注意
        sb = subj_list[s];
        printf sb " : ";
        for ( k = 1; k <= score_num; k++ ) {    # 添字の範囲に注意
            sc = score_list[k];
            printf subj_score[sb][sc]+0 " ";
        }
        print "";
    }
    print "";

    ##--  学生と科目の成績表
    print "学生と科目の成績表";
    print "       " subj_all;
    for ( st in score ) {
        printf st " : ";
        for ( s = 1; s <= subj_num; s++ ) {    # 添字の範囲に注意
            sb = subj_list[s];
            sc = score[st][sb];
            if ( sc == "" ) { sc = "X"; }
            printf "  " sc "  ";
        }
        print "";
    }
    print "";

    ##--  成績一覧
    print "成績一覧";
    for ( idx1 in score ) {
        point = 0;
        total = 0;
        for ( idx2 in score[idx1] ) {
            sc = score[idx1][idx2];
            if ( sc == "" ) { sc = "X"; } else { total++; }
            print idx1 " " idx2 " : " sc;
            point += gpa[sc];
        }
        print total " " point " " point / total;
    }
}
