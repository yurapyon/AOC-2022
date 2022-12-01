\ note: assumes no elf will carry 0 calories

\ === input ===

0 value in-file

: open-input  s" files/01-input" r/o open-file throw to in-file ;
: reset-input 0 0 in-file reposition-file throw ;
: close-input in-file close-file throw ;

256 constant max-line
create line-buffer max-line 1 + chars allot

: read-to-buf ( -- t/f-eof )
  line-buffer max-line in-file read-line throw
  swap line-buffer + 0 swap ! ;

: buf>number  ( -- number ) 0 0 line-buffer max-line >number 2drop drop ;

\ === math ===

0 value curr
0 value max0
0 value max1
0 value max2

: reset-counts 0 to curr 0 to max0 0 to max1 0 to max2 ;

: process ( xt -- )
  buf>number ?dup if
    curr + to curr
    drop
  else
    execute
    0 to curr
  then
  ;

: update-max
  curr max0 max to max0
  ;

: update-maxes
  curr max0 > if
    max1 to max2
    max0 to max1
    curr to max0
  else
    curr max1 > if
      max1 to max2
      curr to max1
    else
      curr max2 > if
        curr to max2
      then
    then
  then
  ;

: get-sum max0 max1 max2 + + ;

\ === main ===

: part1
  begin read-to-buf
  while ['] update-max process repeat
  max0 . cr
  ;

: part2
  begin read-to-buf
  while ['] update-maxes process repeat
  get-sum . cr
  ;

: main
  cr
  open-input
  part1
  reset-input reset-counts
  part2
  close-input
  bye
  ;

main
