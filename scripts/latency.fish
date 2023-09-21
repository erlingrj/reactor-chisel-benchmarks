argparse "n/nocompile" "o/output=" -- $argv

if set -q _flag_output
    set DEST $_flag_output
else
    set DEST results/latency
end

echo Writing results to `$DEST`
echo Root is $ROOT
mkdir -p $DEST

set EVAL $ROOT/evaluation

# Compile
if not set -q _flag_nocompile
    # Empty old binaries and executables
    rm -rf src-gen/*
    rm -rf bin/*
    for src in $EVAL/src/latency/*
        clfc $src
    end
end

# Do characterization
for bin in $EVAL/bin/*
    $bin > $DEST/(basename $bin).txt 2>&1
end

# Extract a latex table
# $EVAL/scripts/createResourceTable.py $DEST


