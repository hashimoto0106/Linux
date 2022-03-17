# regmacro.awk    [5.4節]


# 正規表現のマクロ展開
function  regmacro(reg)  {
    gsub(/@1/, "(" ESUB[1] ")", reg); gsub(/@2/, "(" ESUB[2] ")", reg)
    gsub(/@3/, "(" ESUB[3] ")", reg); gsub(/@4/, "(" ESUB[4] ")", reg)
    gsub(/@5/, "(" ESUB[5] ")", reg); gsub(/@6/, "(" ESUB[6] ")", reg)
    gsub(/@7/, "(" ESUB[7] ")", reg); gsub(/@8/, "(" ESUB[8] ")", reg)
    gsub(/@9/, "(" ESUB[9] ")", reg); gsub(/@0/, "(" ESUB[0] ")", reg)
    while ( match(reg, /{[^}]+}!/) > 0 )  {
        ins = regcyc(substr(reg, RSTART, RLENGTH))
        reg = erase(reg, RSTART, RLENGTH)
        reg = insert(reg, RSTART, ins)
    }
    while ( match(reg, /{[^}]+}#/) > 0 )  {
        ins = regsub(substr(reg, RSTART, RLENGTH))
        reg = erase(reg, RSTART, RLENGTH)
        reg = insert(reg, RSTART, ins)
    }
}


##### 参照関数 #####

# insert()    [4.2節]  str.awk
function  insert(str, pos, ins)  {
    return jsubstr(str, 1, pos) ins jsubstr(str, pos+1)
}


# erase()     [4.2節]  str.awk
function  erase(str, pos, len)  {
    return jsubstr(str, 1, pos-1) jsubstr(str, pos+len)
}


# regesc()    [4.2節]  str.awk
function  regesc(str)  {
    gsub(/\\/, "\\\\", str)
    gsub(/\|/, "\\\|", str)
    gsub(/\?/, "\\\?", str)
    gsub(/\+/, "\\\+", str)
    gsub(/\*/, "\\\*", str)
    gsub(/\$/, "\\\$", str)
    gsub(/\^/, "\\\^", str)
    gsub(/\./, "\\\.", str)
    gsub(/\(/, "\\\(", str)
    gsub(/\)/, "\\\)", str)
    gsub(/\[/, "\\\[", str)
    gsub(/\]/, "\\\]", str)
    return str
}

# regsub()    [4.2節]  str.awk
function  regsub(str,  ret, i)  {
    ret = regesc(str)
    for ( i = jlength(str)-1; i >= 1; i-- )
        ret = ret "|" regesc(jsubstr(str, 1, i))
    return ret
}

# regcyc()    [4.2節]  str.awk
function  regcyc(str,  ret, i)  {
    ret = regesc(str)
    for ( i = 1; i <= jlength(str)-1; i++ )
        ret = ret "|" regesc(jsubstr(str, i+1) jsubstr(str, 1, i))
    return ret
}
