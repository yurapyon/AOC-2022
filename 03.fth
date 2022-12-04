: flip ( a b c - c b a ) -rot swap ;
: c!or ( val addr -- ) dup c@ rot or swap c! ;

\ === input ===

0 value in-file

: open-input  r/o open-file throw to in-file ;
: reset-input 0 0 in-file reposition-file throw ;
: close-input in-file close-file throw ;

64 constant max-line

: create-buffer create max-line chars cell + allot ;
: buffer-end ( addr ) max-line chars + ;
: read-to-buffer ( addr -- t/f-eof )
  dup max-line in-file read-line throw ( addr len t/f-eof )
  flip buffer-end ! ;
: buf-len buffer-end @ ;
: half-len buf-len 2 / ;

create-buffer lb1
create-buffer lb2
create-buffer lb3

: read-3-to-buffer ( -- t/f-eof )
  lb1 read-to-buffer drop
  lb2 read-to-buffer drop
  lb3 read-to-buffer ;

\ ===

: char>priority ( char -- idx )
  dup [char] a > if
  [char] a - 1 + else
  [char] A - 27 + then ;

create tbl 256 chars allot
: clear-table tbl 256 chars 0 fill ;
: table-idx tbl + ;

: read-to-table ( or-with start len -- )
  over + swap ?do
    dup i c@ table-idx c!or loop
  drop ;
: read-buffer-to-table dup buf-len read-to-table ;

: check-table ( for -- ch )
  [char] [ [char] A ?do
    dup i table-idx c@ = if drop i unloop exit then
  loop
  [char] { [char] a ?do
    dup i table-idx c@ = if drop i unloop exit then
  loop ;

0 value total
: +total total + to total ;
: reset-total 0 to total ;

\ ===

: part1 ( -- )
  begin lb1 read-to-buffer
  while
    clear-table
    %01 lb1 lb1 half-len                read-to-table
    %10 lb1 lb1 half-len + lb1 half-len read-to-table
    %11 check-table char>priority +total
  repeat
  total . cr ;

: part2 ( -- )
  begin read-3-to-buffer
  while
    clear-table
    %001 lb1 read-buffer-to-table
    %010 lb2 read-buffer-to-table
    %100 lb3 read-buffer-to-table
    %111 check-table char>priority +total
  repeat
  total . cr ;

: reset reset-input reset-total ;

: main
  s" files/03-input" open-input
  part1 reset part2
  close-input bye ;

main
