\ === input ===

256 constant max-line
create line-buffer max-line 1 + chars allot

0 value in-file

: open-input
  s" files/01-input" r/o open-file throw to in-file
  ;

: reset-input
  0 in-file reposition-file throw
  ;

: close-input
  in-file close-file throw
  ;

: read-line ( -- t/f-was-number t/f-was-eof )
  line-buffer max-line in-file read-line throw
  over line-buffer + 0 swap !
  ;

: buf>number ( -- number )
  0 0 line-buffer max-line >number 2drop drop
  ;

\ === math ===

0 value curr

0 value max0
0 value max1
0 value max2

: reset-counts
  0 to curr
  0 to max0
  0 to max1
  0 to max2
  ;

: process-part1 ( t/f-was-number -- )
  if
    buf>number
    curr + to curr
  else
    curr max0 max to max0
    0 to curr
  then
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

: get-sum
  max0 max1 max2 + +
  ;

: process-part2 ( t/f-was-number -- )
  if
    buf>number
    curr + to curr
  else
    update-maxes
    0 to curr
  then
  ;

\ === main ===

: part1
  begin
    read-line
  while
    process-part1
  repeat
  max0 . cr
  ;

: part2
  begin
    read-line
  while
    process-part2
  repeat
  get-sum . cr
  ;

: main
  cr
  open-input
  part1
  reset-input
  reset-counts
  part2
  close-input
  bye
  ;

main
