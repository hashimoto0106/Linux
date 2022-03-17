NR == 1  {
    for ( k = 1; k <= NF; k++ )  set1[$k] = 1;
}

NR == 2  {
    for ( k = 1; k <= NF; k++ )  set2[$k] = 1;
}


END  {
    printf "1: "; set_output(set1);
    printf "2: "; set_output(set2);
    print "";
    
    n = set_common(set0, set1, set2);
    printf("C: %2d ; ", n); set_output(set0);

    n = set_union(set0, set1, set2);
    printf("U: %2d : ", n); set_output(set0);

    n = set_diff(set0, set1, set2);
    printf("D: %2d ; ", n); set_output(set0);

    n = set_xor(set0, set1, set2);
    printf("X: %2d ; ", n); set_output(set0);

    ##====  直積(!! 本文にはない追加)
    print ""
    n =  set_product(prd0, set1, set2);
    printf "P: " n " ; "; prd_output(prd0);
}

##====  集合の要素数
function set_size(s,   e, n) {
    for ( e in s )  if ( s[e] == 1 )  n++
    return n
}

##====  集合の正規化
function set_normal(s,   e) {
    for ( e in s )
	if ( e == "" || s[e] == "" )  delete e
}

##====  集合の複写
function set_copy(s0, s1,   e) {
    for ( e in s1 )  s0[e] = 1
}

##====  集合の整列
function set_sort(s,   t, e) {
    PROCINFO["sorted_in"] = "@ind_str_asc"
    for ( e in s )  t[e] = 1
    set_copy(s, t)
}

##====  集合の出力
function set_output(s,   e) {
    PROCINFO["sorted_in"] = "@ind_str_asc"
    for ( e in s )  printf e " "
    print ""
}

##====  集合の所属性
function set_elem(s, e) {
    if ( s[e] == 1 ) { return 1; } else { delete s[e]; return 0; }
}

##====  集合の包含性
function set_inc(s1, s2,   e) {
    for ( e in s1 )  if ( ! set_elem(s2, e) )  { return 0; }
    return 1
}

##====  集合の相等性
function set_equ(s1, s2,   e) {
    return (set_inc(s1, s2) && set_inc(s1, s2))
}

##====  共通集合
function set_common(s0, s1, s2,   e, n) {
    delete(s0)
    for ( e in s1 )
        if ( set_elem(s2, e)  ) s0[e] = 1
    return set_size(s0)
}

##====  合併集合
function set_union(s0, s1, s2,   e, n) {
    delete(s0)
    for ( e in s1 )  s0[e] = 1
    for ( e in s2 )  s0[e] = 1
    return set_size(s0)
}

##====  相対補集合(差集合)
function set_diff(s0, s1, s2,   e, n) {
    delete(s0)
    for ( e in s1 )
        if ( ! set_elem(s2, e)  ) s0[e] = 1
    return set_size(s0)
}

##====  対角差集合(排他的和集合)
function set_xor(s0, s1, s2,   t1, t2) {
    delete(t1); set_diff(t1, s1, s2)
    delete(t2); set_diff(t2, s2, s1)
    set_union(s0, t1, t2)
    return set_size(s0)
}

##====  直積の出力
function prd_output(p,   e) {
    for ( e in p )  printf "<" e "> "
    print ""
}

##====  直積
function set_product(p0, s1, s2,   e1, e2, n) {
    delete(p0);
    SUBSEP = ","
    for ( e1 in s1 )  for ( e2 in s2 )  p0[e1,e2] = 1
    return set_size(p0)
}
