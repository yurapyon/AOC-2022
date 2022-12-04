: flip ( a b c - c b a ) -rot swap ;
: >snumber ( addr len -- addr len number )
  >r >r 0 0 r> r> >number
  >r >r drop r> r> rot ;

\ === input ===

0 value in-file

: open-input  r/o open-file throw to in-file ;
: reset-input 0 0 in-file reposition-file throw ;
: close-input in-file close-file throw ;

16 constant max-line
create line-buffer max-line 1 + chars allot

: read-to-buffer ( -- buf-len t/f-eof )
  line-buffer max-line in-file read-line throw ;

: skip,- 1- swap 1+ swap ;
: next-number skip,- >snumber ;

0 value e1-start
0 value e1-end
0 value e2-start
0 value e2-end

: ranges> e1-start e1-end e2-start e2-end ;

: read-to-ranges ( buf-len -- )
  line-buffer swap >snumber to e1-start
  next-number to e1-end
  next-number to e2-start
  next-number to e2-end
  2drop ;

\ === math ===

: range-within   ( s1 e1 s2 e2 -- t/f ) rot  <= -rot <= and ;
: range-overlaps ( s1 e1 s2 e2 -- t/f ) flip <= -rot <= and ;
: test-ranges ( xt -- t/f )
  >r ranges> r@ execute
  ranges> 2swap r> execute
  or ;

\ === main ===

0 value ct
: +ct ct + to ct ;
: reset-ct 0 to ct ;

: process-file ( xt -- )
  begin read-to-buffer
  while
    read-to-ranges
    dup test-ranges 1 and +ct
  repeat drop
  ct . cr ;

: part1 ['] range-within process-file ;
: part2 ['] range-overlaps process-file ;
: reset reset-input reset-ct ;

: main
  s" files/04-input" open-input
  part1 reset part2
  close-input bye ;

main
