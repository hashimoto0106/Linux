##--------------------------------------------------------------------
##
##--------------------------------------------------------------------

END  {
    ##----
    TFS = "|"; TRS = "-"; TXS = "+"; TLS = TXS;
    ##----
    for ( j = 1; j <= COL; j++ )  { TLS = TLS repeat(TRS, WID[j])  TXS }
    print TLS;
    for ( i = 1; i <= LINE; i++ )  {
        for ( j = 1; j <= COL; j++ ) {
            width = WID[j]
            str_len = length(FLD[i, j])
            fld_len = str_width(FLD[i, j])
            if ( str_len != fld_len )  width =  WID[j] - str_len
            printf(TFS "%" width "s", FLD[i, j])
        }
        print TFS "\n" TLS
    }
}

##--------------------------------------------------------------------
##
##--------------------------------------------------------------------

function repeat(s, n,  p, k) {
    for ( k = 1; k <= n; k++ )  p = p s;
    return p;
}
