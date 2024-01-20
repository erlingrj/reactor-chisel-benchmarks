#!/usr/bin/fish
argparse "n/nocompile" "o/output=" -- $argv

if set -q _flag_output
    set DEST $_flag_output
else
    set DEST results/throughput
end

echo Writing results to `$DEST`
mkdir -p $DEST

# Compile
if not set -q _flag_nocompile
    # Empty old binaries and executables
    rm -rf src-gen/*
    rm -rf bin/*
    for src in src/throughput/*
        lingua-franca/bin/lfc $src
    end
end

# Do characterization
for bin in bin/*
    $bin > $DEST/(basename $bin).txt 2>&1
end