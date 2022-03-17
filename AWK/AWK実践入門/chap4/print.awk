# カラー出力
function  printc(str, clr)  {
  printf("\033[" clr "m%s\033[0m", str)
}
