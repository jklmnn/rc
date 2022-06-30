set history save on
set history remove-duplicates unlimited

define qemu
    target extended-remote localhost:1234
    set mem inaccessible-by-default off
end

define qnx
    target qnx $arg0:$arg1
    upload $arg2 /tmp/$arg2
end
