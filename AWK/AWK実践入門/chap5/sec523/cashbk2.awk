# cashbk2.awk	[5.2節]


# 小遣い帳(2)
BEGIN { FS="\t+"; n = 3 }

$1 ~ /^11\/.*/ {
    gsub(",","",$n)
    if (MAX == "" || MAX < $n+0 )  MAX = $n+0
    if (MIN == "" || MIN > $n+0 )  MIN = $n+0
    COUNT++
    TOTAL += $n
}

END {
    print "残高 = " TOTAL;
    print "最大出金額 = " MIN;
    print "最大入金額 = " MAX;
}
