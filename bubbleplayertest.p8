pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
#include bubbleplayer.lua

__gfx__
0000000000cccc00000000000000000011cccc110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000c0000c000000000000000001c0000c10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700c060000c0000000000000000c060000c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000c000000c0008800000088000c000000c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000c000000c0004400000044000c000000c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700c000060c004cc400000cc000c000060c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000c0060c0000cc0000004c0001c0060c10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000cccc00000770000007700011cccc110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
111111114444444444444f4444444444000000001111111111111111000000000000000000000000000000000000000000000000000000000000000000000000
11111111444444fff44444fffff44444000000001111116111116111000000000000000000000000000000000000000000000000000000000000000000000000
11111111fff44444444444444444444f000000001611111111111111000000000000000000000000000000000000000000000000000000000000000000000000
1111111144ff444444444444444444f4000000006161111116111111000000000000000000000000000000000000000000000000000000000000000000000000
111111114444444444f4444444444444000000001611111161611111000000000000000000000000000000000000000000000000000000000000000000000000
1111111144444fffff444444444f4444000000001111111116111111000000000000000000000000000000000000000000000000000000000000000000000000
111111114444444444444f444ff444f4e00e0e001111111111111116000000000000000000000000000000000000000000000000000000000000000000000000
11111111ff444444444444ff4444444f0e0ee0001116111111111111000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000001111116111111111000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000001111161611161111000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000001111161611616111000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000001116116111616111000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000001161611111161111000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000001116111111111611000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000001111111111116161000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000001111111111111611000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000000000000000000000000000000000000000000000000000000000000000000101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
2020202020202020202020202020202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2020202020252020202020362035202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2020202020202020362020202020202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2020252020202020202020202020202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2020202020202026262020202020202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2020202020202020202026202020203600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2020203520202020202020203620203600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2020202222222222222020202020202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2020202020202020202026202020202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2020202036202020202020202020202600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2020202020202020203520202020202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2020203520202020262020222222222200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2020202026202020202020202020202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2020202036202020202035202020202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2020232326202020202620202020202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2121212121212121212121212121212100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
