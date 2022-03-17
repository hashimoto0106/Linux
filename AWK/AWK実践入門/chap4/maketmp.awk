# 一時ファイル名の作成
function  maketmp() 	{
  # TMPDIRディレクトリに書き込みができない場合は、以下ENVIRON["TMPDIR"]を"/tmp", "./"など適切に置き換える
  dir = ENVIRON["TMPDIR"] == "" ? "/tmp" : ENVIRON["TMPDIR"]
  return ( dir "/awk" ++TMPNUM )	# 環境変数
}
