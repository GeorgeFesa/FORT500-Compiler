$ x = 10 * 2
$ if (.true.) then
$     integer l
$     l = 4+8
$ else
$     write 5
$ endif
$ 
$ $ integer i
$ do i = 1, 10 
$     integer b
$     b = i
$ $ enddo
$ 
$ do i=1,n
$    if (a(i) .gt. 0) a(i) = a(i) - i
$ enddo
$ 
$ end

integer b

if (.true.) then
    b = 1
endif

do i = 1, 10 
    if (.true.) then
        integer b
        b = 7    
    endif
enddo

end

$ subroutine example(real n)
    $ n = 5
$ end

goto 10
