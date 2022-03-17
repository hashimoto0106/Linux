##=================================================================
## ローリングハッシュによる文字列探索
## rk_search.awk
##=================================================================

BEGIN {
    text_file = ARGV[1]
    pattern_file = ARGV[2]
    getline pat < pattern_file
    getline txt < text_file
    pat_len = length(pat)
    txt_len = length(txt)

    pat_hash =  calc_init_hash(pat, pat_len)

    txt_hash =  calc_init_hash(txt, pat_len)
    i = 0
    while ( pat_hash != txt_hash ) {
        i++
        txt_hash =  calc_rolling_hash(txt_hash, txt, pat_len, i)

        if ( i > txt_len ) {
            print "not found"
            exit
        }
    }
    print "found at ", i
    print txt
    for ( k = 0; k < i; k++ ) {
        printf " "
    }
    print pat
}

##=================================================================
## 関数定義
##=================================================================

function calc_init_hash (str, pat_len, hash, i) {
    hash = 0 # 文字列のハッシュ値

    for ( i = 1; i <= pat_len; i++) {
        hash = lshift(hash, 1)
        hash += ascii(substr(str, i, 1))
    }

    return hash
}

function calc_rolling_hash (hash, str, pat_len, cur_pos) {
    sub_code = ascii(substr(str, cur_pos, 1))
    add_code = ascii(substr(str, cur_pos+pat_len, 1))

    hash -= lshift(sub_code, pat_len-1)
    hash = lshift(hash, 1)
    hash += add_code
    return hash
}

#-- Chap4 ascii.awkの関数
function ascii(c,    ascii_str)
{
    ascii_str=" !\"#$%&'()*+,-./0123456789:;<=>?@"
    ascii_str=ascii_str "ABCEFFGHIJKLMNOPQRSTUVWXYZ[\\]^_`"
    ascii_str=ascii_str "abceffghijklmnopqrstuvwxyz{|}~"
    return (31 + index(ascii_str, c))
}
