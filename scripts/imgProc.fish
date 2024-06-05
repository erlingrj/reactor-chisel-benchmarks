#!/usr/bin/fish
argparse "n/nocompile" "c/nochar" "o/output=" -- $argv

if set -q _flag_output
    set DEST $_flag_output
else
    set DEST results/imgProcLF
end

echo Writing results to `$DEST`
mkdir -p $DEST

# Compile
if not set -q _flag_nocompile
    lingua-franca/bin/lfc $srcFile -c
end

# Do characterization
if not set -q _flag_nochar
    set BUILD_DIR results_ZedBoardWrapper.v
    pushd codesign-gen/ImageFiltering/src-gen/hardware/_FpgaTop/build
    # Run OMX
    $OHMYXILINX/vivadocompile.sh ZedBoardWrapper.v clock xc7z020clg484-1
    # Copy results back
    cp $BUILD_DIR/res.txt $DEST/img_proc.txt
    cp $BUILD_DIR/util_report.txt $DEST/img_proc_util_report.txt
    cp $BUILD_DIR/timing_report.txt $DEST/img_proc_timing_report.txt
    popd
end

