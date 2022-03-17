# list.awk	[5.8節]


# 標準化
function  normalize(data)  {
    gsub(/\(/, " ( ", data)
    gsub(/\)/, " ) ", data)
    gsub(/(\t| )+/, " ", data)
    gsub(/(^ | $)/, "", data)
    return data
}

# アトム判定
function  li_atomp(data)  {
    if ( match(data, /^[^() ]+$/) )  return 1
    else return 0
}

# 空リスト判定
function  li_nullp(data) {
    if ( match(data, /^ *\( *\) *$/) )  return 1
    else return 0
}

# リスト判定
function  li_listp(data,  key, lev)  {
    if ( data !~ /^ *\(.*\) *$/ )  return 0
    while ( match(data, /\(|\)/) > 0 )  {
        key  = substr(data, RSTART, 1)
        data = substr(data, RSTART+1)
        if ( key == "(" )  lev++
        else  if ( --lev == 0 && data !~ /^ *$/ )  return 0
    }
    if ( lev )  return 0
    else return 1
}

# car部
function  car(data,  len, arr, num, lev, ret)  {
    data = normalize(data)
    if ( li_listp(data) == 0 )  return  "ERROR"
    len = split(data, arr)
    if ( arr[2] == ")" )  return "ERROR"
    if ( arr[2] != "(" )  return arr[2]
    for (num = 2; num <= len; num++)  {
        ret = ret " " arr[num]
        if ( arr[num] == "(" )  lev++
        else  if ( arr[num] == ")" )
            if  ( --lev == 0 )  return substr(ret, 1)
    }
}

# cdr部
function  cdr(data,  len, arr, num, lev, ret)  {
    data = normalize(data)
    if ( li_listp(data) == 0 )  return  "ERROR"
    len = split(data, arr)
    if ( arr[2] == ")" )  return "ERROR"
    if ( arr[2] != "(" )
        for (num = 3; num <= len; num++)  ret = ret " " arr[num]
    else {
        for (num = 2; num <= len; num++)  {
            if ( arr[num] == "(" )  lev++
            else  if ( arr[num] == ")" )  if  ( --lev == 0 )  break
        }
        while ( num <= len )  ret = ret " " arr[++num]
    }
    return "(" ret
}

# cons結合
function  cons(car, cdr)  {
    car = normalize(car)
    cdr = normalize(cdr)
    if ( li_listp(car) == 0 && li_atomp(car) == 0 )  return "ERROR"
    if ( li_listp(cdr) == 0 )                     return "ERROR"
    return "( " car " " substr(cdr, 3)
}
