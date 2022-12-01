: 3drop 2drop drop ;
: sort ( a b -- min max )
  2dup > if swap then ;

\ === input ===

0 value in-file

: open-input  r/o open-file throw to in-file ;
: reset-input 0 0 in-file reposition-file throw ;
: close-input in-file close-file throw ;

16 constant max-line
create line-buffer max-line 1 + chars allot

: read-to-buffer ( -- buf-len t/f-eof )
  line-buffer max-line in-file read-line throw ;

: buffer>number ( ct -- number )
  >r 0 0 line-buffer r> >number 3drop ;

\ === math ===

0 value acc
0 value max0
0 value max1
0 value max2

: reset-acc   0 to acc ;
: reset-maxes 0 to max0 0 to max1 0 to max2 ;
: inc-acc     acc + to acc ;

: process ( xt buf-len -- xt )
  ?dup if buffer>number inc-acc
  else dup execute reset-acc
  then ;

: update-max2 acc max2 max to max2 ;

: update-maxes
  update-max2
  max1 max2 sort to max1 to max2
  max0 max1 sort to max0 to max1 ;

: get-sum max0 max1 max2 + + ;

\ === main ===

: process-file ( xt -- )
  begin read-to-buffer
  while process repeat
  drop ;

: part1
  ['] update-max2 process-file
  max2 . cr ;

: part2
  ['] update-maxes process-file
  get-sum . cr ;

: reset reset-input reset-acc reset-maxes ;

: main
  s" files/01-input" open-input
  part1 reset part2
  close-input bye ;

main
