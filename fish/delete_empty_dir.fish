#!/usr/bin/env fish

set count 0
for dir in (find . -maxdepth 2 -type d -empty)
    echo "Deleting: $dir"
    rmdir $dir
    if test $status -eq 0
        set count (math $count + 1)
    end
end
echo "Total empty directories deleted: $count"