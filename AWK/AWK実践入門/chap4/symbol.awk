# 文字の出現回数
{  
  for ( i = 1; i <= length($0); i++ )  {  
    char = substr($0, i, 1)		
    list[char]++
  }
}

END {
  for ( char in list )  
    if ( char != "\t" )  printf("%2s\t%3d\n", char, list[char])
    else printf("\\t  %3d\n", list[char])
}
