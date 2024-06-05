#!/usr/bin/fish
argparse "n/nocompile" "c/nochar" "o/output=" -- $argv

if set -q _flag_output
    set DEST $_flag_output
else
    set DEST results/res
end

echo Writing results to `$DEST`
mkdir -p $DEST

# Compile
if not set -q _flag_nocompile
    # Empty old binaries and executables
    rm -rf src-gen/*
    rm -rf bin/*

    for src in src/res/*
        lingua-franca/bin/lfc $src
    end
end

# Do characterization
if not set -q _flag_nochar
    set BUILD_DIR build/results_StandaloneTopReactor
    for gen in src-gen/res/*
        pushd $gen
        sbt 'run characterize'
        cp $BUILD_DIR/res.txt $DEST/(basename $gen).txt
        cp $BUILD_DIR/util_report.txt $DEST/(basename $gen)_util_report.txt
        cp $BUILD_DIR/timing_report.txt $DEST/(basename $gen)_timing_report.txt
        popd
    end
end