# クイックソート
function  qsort(arr, left, right,  i, j, x, tmp)  {
  if ( left == right )  return
  i = left; j = right
  x = arr[int((left + right)/2)]
  for ( ; ; ) {
    while ( arr[i] < x )  i++
    while ( x < arr[j] )  j--
    if ( i > j )  break
    tmp = arr[i]; arr[i] = arr[j]; arr[j] = tmp
    i++
    j--
  }
  if ( left < j )  qsort(arr, left, j)
  if ( i < right ) qsort(arr, i, right)
}
