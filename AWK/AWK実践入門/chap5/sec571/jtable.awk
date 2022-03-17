##--------------------------------------------------------------------
##
##--------------------------------------------------------------------

END  {
    ##----  細枠
    TFS1 = "｜"; TFS2 = "｜"; TFS3 = "｜"
    TRS1 = "—"; TRS2 = "—"; TRS3 = "—"
    TXS1 = "┌"; TXS2 = "┬"; TXS3 = "┐"
    TXS4 = "├"; TXS5 = "┼"; TXS6 = "┤"
    TXS7 = "└"; TXS8 = "┴"; TXS9 = "┘"

    # 外側だけ太枠にする場合
    # TFS1 = "┃"; TFS2 = "│"; TFS3 = "┃"
    # TRS1 = "━"; TRS2 = "─"; TRS3 = "━"
    # TXS1 = "┏"; TXS2 = "┯"; TXS3 = "┓"
    # TXS4 = "┠"; TXS5 = "┼"; TXS6 = "┨"
    # TXS7 = "┗"; TXS8 = "┷"; TXS9 = "┛"

    TLS1 = TXS1; TLS2 = TXS4; TLS3 = TXS7
    for ( j = 1; j <= COL; j++ )  {
        if ( WID[j]%2 == 1 )  WID[j]++
        TLS1 = TLS1 repeat(TRS1, WID[j])
        TLS2 = TLS2 repeat(TRS2, WID[j])
        TLS3 = TLS3 repeat(TRS3, WID[j])
        if ( j < COL ) { TLS1 = TLS1 TXS2; TLS2 = TLS2 TXS5; TLS3 = TLS3 TXS8 }
    }
    TLS1 = "\n" TLS1 TXS3; TLS2 = "\n" TLS2 TXS6; TLS3 = "\n" TLS3 TXS9

    print TLS1
    for ( i = 1; i <= LINE; i++ )  {
        printf TFS1
        for ( j = 1; j <= COL; j++ ) {
            width = WID[j]
            str_len = length(FLD[i, j])
            if ( str_len != width ) {
                width += (WID[j]-str_len)
            }
            printf("%" width "s", FLD[i, j])
            if ( j < COL )  { printf TFS2 }  else { printf TFS3 }
        }
        if ( i < LINE )  { print TLS2 }  else { print TLS3 }
    }
}


##--------------------------------------------------------------------
##
##--------------------------------------------------------------------

function repeat(s, n,  p, k) {
    for ( k = 1; k <= n; k++ )  p = p s;
    return p;
}
