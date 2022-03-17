# 横二段出力
END  {
  WMX = 0; for ( j = 1; j <= COL; j++ )  { if ( WMX < WID[j] )  WMX = WID[j] }
  mm = "%" WMX "s"
  po = int((COL+1)/2)
  for  ( i = 1; i <= LINE; i++ )  {
    for  ( j = 1; j <= po; j++ )  { 
      printf(mm, FLD[i, j])
      if ( j < po )  { printf OFS }  else { printf ORS }
    }
  }
  printf ORS
  for  ( i = 1; i <= LINE; i++ )  {
    for  ( j = po+1; j <= COL; j++ )  { 
      printf(mm, FLD[i, j])
      if ( j < COL )  { printf OFS }  else { printf ORS }
    }
  }
}
