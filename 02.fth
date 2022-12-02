\ === input ===

0 value in-file

: open-input  r/o open-file throw to in-file ;
: reset-input 0 0 in-file reposition-file throw ;
: close-input in-file close-file throw ;

16 constant max-line
create line-buffer max-line 1 + chars allot

: read-to-buffer ( -- t/f-eof )
  line-buffer max-line in-file read-line throw
  nip ;

\ === rps ===

0 constant rock
1 constant paper
2 constant scissors

: hand>score 1+ ;

0 constant loss
1 constant draw
2 constant win

: outcome>score 3 * ;

: elf-pick line-buffer c@     [char] A - ;
: you-pick line-buffer 2 + c@ [char] X - ;

\ some weird math but it works
: round-outcome 1 elf-pick - you-pick + 3 mod ;
: forced-hand   elf-pick 2 + you-pick + 3 mod ;

: round>score
  you-pick hand>score
  round-outcome outcome>score
  + ;

: forced-round>score
  forced-hand hand>score
  you-pick outcome>score
  + ;

\ === main ===

0 value total-score

: +total total-score + to total-score ;
: reset-total 0 to total-score ;

: process-file ( xt -- )
  begin read-to-buffer
  while dup execute +total repeat
  drop
  total-score . cr ;

: part1 ['] round>score process-file ;
: part2 ['] forced-round>score process-file ;
: reset reset-input reset-total ;

: main
  s" files/02-input" open-input
  part1 reset part2
  close-input bye ;

main
