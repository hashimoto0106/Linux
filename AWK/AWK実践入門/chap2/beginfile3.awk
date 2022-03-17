BEGINFILE {
  print FILENAME
  if ( FILENAME ~ /\.hsv$/ ) {
    FS = "-"
  } else if ( FILENAME ~ /\.csv$/ ) {
    FS = ","
  } else {
    FS = "\t"
  }
}

{ print $1 }
