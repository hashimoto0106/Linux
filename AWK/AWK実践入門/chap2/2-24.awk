/インド/ {
  if ( $2 == "西経" && $3 > 60 )
    print "なんだ、アメリカだ";
  else if ( $0 ~ "インドネシア" )
    print "インドネシアだ!";
  else if ( $0 ~ "本物" )
    print "ついにインドを見つけた";
}
