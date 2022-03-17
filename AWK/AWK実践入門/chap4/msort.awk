# マージソート
BEGIN {
  rows = 1000         # ここで指定した行数毎に一時ファイルを作成する
}

l < rows  { l++; ARR[l] = $0 }

l == rows  {
  ARR[l] = $0
  partialsort(ARR, l)
  l = 0
}

END {
  partialsort(ARR, l)
  merge()
  for (i in TMPFILE)  fstr = fstr " " TMPFILE[i]
  system("rm " fstr)
}

# rows行毎にqsort()で処理し、一時ファイルへ書き出す
function  partialsort(ARR, l,    i)  {
  qsort(ARR, 1, l)
  TMPFILE[++FILENO] = maketmp()
  for ( i = 1; i <= l; i++ ) {
    print ARR[i] >> TMPFILE[FILENO]
    delete ARR[i]
  }
  close(TMPFILE[FILENO])
}

# ソート済みの各一時ファイルをマージ処理する
function merge(     i, f)
{
  for ( i in TMPFILE )
    if ( ( getline buf[i]  < TMPFILE[i] ) < 0 )  delete buf[i]
  do {
    i = imin(buf)
    print buf[i]
    if ( ( getline buf[i] < TMPFILE[i] ) < 1 ) {
      close(TMPFILE[i])
      delete buf[i]
      FILENO--
    }
  } while ( FILENO )
}

# 配列の中の最小値を持つメンバへのインデックスを返す
function  imin(arr,   m, i)  {
  for ( i in arr )
    if ( m == "" || arr[i] < arr[m] )  m = i
  return m
}
