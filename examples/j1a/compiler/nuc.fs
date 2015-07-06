: emit
     begin
        d# 0 io@
     until
     d# 1 io!
;

: main
    begin
        \ d# 1 io@ dup if
        \     emit
        \ then
        d# 32 emit
        [char] J emit
        [char] 1 emit
    again
;
