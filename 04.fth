: flip ( a b c - c b a ) -rot swap ;

\ === input ===

0 value in-file

: open-input  r/o open-file throw to in-file ;
: reset-input 0 0 in-file reposition-file throw ;
: close-input in-file close-file throw ;

16 constant max-line
create line-buffer max-line 1 + chars allot

: read-to-buffer ( -- buf-len t/f-eof )
  line-buffer max-line in-file read-line throw ;

0 value e1-start
0 value e1-end
0 value e2-start
0 value e2-end

: >snumber ( addr len -- addr len number )
  >r >r 0 0 r> r> >number
  >r >r drop r> r> rot ;

: skip,- 1- swap 1+ swap ;

: read-to-ranges ( buf-len -- )
  line-buffer swap >snumber to e1-start
  skip,- >snumber to e1-end
  skip,- >snumber to e2-start
  skip,- >snumber to e2-end
  2drop ;

\ === math ===

: range-within   ( s1 e1 s2 e2 -- 1/0 ) rot <= -rot <= and 1 and ;
: range-overlaps ( s1 e1 s2 e2 -- 1/0 ) flip <= -rot <= and 1 and ;
: e1-within-e2 e1-start e1-end e2-start e2-end range-within ;
: e2-within-e1 e2-start e2-end e1-start e1-end range-within ;
: e1-overlaps-e2 e1-start e1-end e2-start e2-end range-overlaps ;
: e2-overlaps-e1 e2-start e2-end e1-start e1-end range-overlaps ;
: reconsider e1-within-e2 e2-within-e1 or ;
: overlaps e1-overlaps-e2 e2-overlaps-e1 or ;

\ === main ===

0 value ct
: +ct ct + to ct ;
: reset-ct 0 to ct ;

: process-file ( xt -- )
  begin read-to-buffer
  while
    read-to-ranges
    dup execute +ct
  repeat drop
  ct . cr ;

: part1 ['] reconsider process-file ;
: part2 ['] overlaps process-file ;
: reset reset-input reset-ct ;

: main
  s" files/04-input" open-input
  part1 reset part2
  close-input bye ;

main
