set history save on
set history remove-duplicates unlimited

define qemu
    target extended-remote localhost:1234
    set mem inaccessible-by-default off
end
