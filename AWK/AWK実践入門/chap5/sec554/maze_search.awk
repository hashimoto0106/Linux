##====================================================================
##  本体処理
##====================================================================

{
    Maze[NR][1] = ""
    split($0, Maze[NR])
    if ( ny < NF )  ny = NF    # 横 (!! 本文からの修正)
}

END  {
    nx = NR                    # 縦 (!! 本文からの修正)
    maze_search(1, 1)
    maze_output(nx, ny)
}

##====================================================================
##  関数定義
##====================================================================

##====  迷路の探索
function maze_search(x, y) {
    ##----  行止り
    if ( x < 1 || x > nx )  return 0    # X範囲外
    if ( y < 1 || y > ny )  return 0    # Y範囲外
    if ( Maze[x][y] != 0 )  return 0    # 壁
    ##----  進行
    Maze[x][y] = 2    # 足跡を付ける
    ##----  ゴール到着
    if ( x == nx && y == ny )  return 1
    ##----  4方向の探索
    if ( maze_search(x+1, y  ) )  return 1
    if ( maze_search(x,   y+1) )  return 1
    if ( maze_search(x-1, y  ) )  return 1
    if ( maze_search(x,   y-1) )  return 1
    ##----  探索失敗
    Maze[x][y] = 0    # 足跡を消す (!! 本文からの修正)
    return 0
}

##====  迷路の出力
function maze_output(nx, ny) {
    for ( kx = 1; kx <= nx; kx++ ) {
        for ( ky = 1; ky <= ny; ky++ ) {
            printf Maze[kx][ky]+0 " "    # (!! 本文からの修正)
        }
        print ""
    }
}
