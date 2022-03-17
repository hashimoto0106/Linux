# テキストの大きさ
{
  c[FILENAME] += length($0)
  w[FILENAME] += NF
  l[FILENAME]++
}

END {
  for (f in c) {
    printf("%d\t%d\t%d\t%s\n", l[f], w[f], c[f], f)
    tc += c[f]
    tw += w[f]
    tl += l[f]
  }
  printf("%d\t%d\t%d\ttotal\n", tl, tw, tc)
}
