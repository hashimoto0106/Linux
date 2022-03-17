# address.awk	[5.2節]


# 住所録
BEGIN { FS="\t+"; name = option(); }
$2 == name {
    key = $1;
    printf "名前\t\t%s\n", $2;
    printf "電話番号\t%s\n", $3;
    printf "住所\t\t%s\n", $4;
    getjob($5);
    getfamily(key);
}


##### 関数定義 #####

# 家族構成の情報
function getfamily(key,   n)
{
    printf "家族構成\n";
    while (getline < "family.txt" > 0)
        if ($1 == key) {
            printf("\t%s\t\t続柄 %s\n", $2, $3);
            n++;
        }
    if (n == 0)
        print "\tなし";
}

# 勤務先の情報
function getjob(abbreviation)
{
    while (getline < "jobs.txt" > 0)
        if ($1 == abbreviation)
            printf "勤務先\t\t%s\t\t電話%s\n", $2, $3;
}


##### 参照関数 #####

# option()  [4.4節]  option.awk
function  option(opt)  {
  if (ARGC > 1 && ARGV[1] ~ /^\+.*$/)  {  # オプション指定のチェック
      opt = substr(ARGV[1], 2)            # 先頭の"+"を取り除く
      delete ARGV[1]                      # 配列を解放する
  }
  return opt
}
