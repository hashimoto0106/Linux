# time.awk	[4.3節]

# 秒数の換算
function  hms(num, arr)  {
  arr["day"] = int(num/(3600*24))
  arr["hour"] = int((num-arr["day"]*24)/3600)
  arr["min"] = int((num%3600)/60)
  arr["sec"] = num%60
}
