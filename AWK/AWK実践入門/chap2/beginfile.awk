BEGIN {
  print "処理を開始します"
}

BEGINFILE {
  if ( ERRNO ) {
    print "ファイル名       : " FILENAME
    print "エラーメッセージ : " ERRNO
    exit
  }
}

END {
  print "処理が終了しました"
}
