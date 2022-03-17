# char.awk	[4.2節]

# 10進アスキーコード
function  ascii(char, ascii_str)  {
  ascii_str = " !\"#$%&'()*+,-./0123456789:;<=>?@"
  ascii_str = ascii_str "ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`"
  ascii_str = ascii_str "abcdefghijklmnopqrstuvwxyz{|}‾"
  return  31+index(ascii_str, char)	# 32から126まで
}					

