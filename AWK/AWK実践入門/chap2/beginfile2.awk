BEGIN {
  print "処理を開始します"
}

BEGINFILE {
  if ( ERRNO ) {
    print "ファイル名       : " FILENAME
    print "エラーメッセージ : " ERRNO
    nextfile
  }
  print FILENAME "を処理します"
}

END {
  print "処理が終了しました"
}
