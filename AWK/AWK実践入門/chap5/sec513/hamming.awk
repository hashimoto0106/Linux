function hamming(s1, s2,  ct) {
    ct = 0;
    while ( s1 != "" && s2 != "" ) {
        c1 = substr(s1, 1, 1); s1 = substr(s1, 2);
        c2 = substr(s2, 1 ,1); s2 = substr(s2, 2);
        if ( c1 != c2 ) { ct++; }
    }
    ct += length(s1) + length(s2);
    return ct;
}
