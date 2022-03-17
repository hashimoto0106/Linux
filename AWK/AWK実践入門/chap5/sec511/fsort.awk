# 単純ソート
BEGIN  {
  n = option()
}

{
  for ( i = 1; i <= NR+1; i++ )  {
    if ( $n >= degree[i] )  {
      for ( j = NR+1; j > i; j-- )  {
        deg = degree[j]
        it = item[j]
        item[j] = item[j-1]
        degree[j] = degree[j-1]
      }
      item[i] = $0
      degree[i] = $n
      break
    }
  }
}

END  {
  for ( i = 1; i <= NR; i++ )  print item[i]
}
