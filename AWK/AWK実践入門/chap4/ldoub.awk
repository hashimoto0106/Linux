# 縦二段出力
END  {
  mm = "%" WMX "s"
  po = int((LINE+1)/2)
  for  ( i = 1; i <= po; i++ )  {
    for  ( j = 1; j <= COL; j++ )  { 
      printf(mm, FLD[i, j])
      if ( j < COL )  { printf OFS }  else { printf OFS OFS }
    }
    for  ( j = 1; j <= COL; j++ )  { 
      printf(mm, FLD[i+po, j])
      if ( j < COL )  { printf OFS }  else { printf ORS }
    }
  } 
}
