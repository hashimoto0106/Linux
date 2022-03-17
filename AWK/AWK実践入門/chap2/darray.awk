{
  for ( i=1; i<=NF; i++ ) {
    darr[FNR][i] = $i
  }
}

END {
  for ( i=1; i<=FNR; i++ ) {
    for ( j=1; j<=NF; j++ ) {
      printf("darr[%d][%d] = %s\n", i, j, darr[i][j])
    }
  }
}
