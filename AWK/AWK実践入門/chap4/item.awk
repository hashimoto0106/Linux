# フィールドの出現回数
{  
  for ( i = 1; i <= NF; i++ )  list[$i]++ 
}

END  { 
  for ( item in list )  printf("%3d  %s\n", list[item], item)
}
