argparse "n/nocompile" "c/nochar" "o/output=" -- $argv

if set -q _flag_output
    set DEST $_flag_output
else
    set DEST results/res
end

echo Writing results to `$DEST`
mkdir -p $DEST

set EVAL $ROOT/evaluation

set srcFile src/img/ImageFiltering.lf 

# Compile
if not set -q _flag_nocompile
    sed -i "s/VerilatedTester/ZedBoard/g" "$srcFile"
    clfc $srcFile -c
    sed -i "s/ZedBoard/VerilatedTester/g" "$srcFile"
end

# Do characterization
if not set -q _flag_nochar
    set BUILD_DIR results_ZedBoardWrapper.v
    pushd $EVAL/codesign-gen/ImageFiltering/src-gen/hardware/_FpgaTop/build
    # Run OMX
    $OHMYXILINX/vivadocompile.sh ZedBoardWrapper.v clock xc7z020clg484-1
    # Copy results back
    cp $BUILD_DIR/res.txt $EVAL/$DEST/img_proc.txt
    cp $BUILD_DIR/util_report.txt $EVAL/$DEST/img_proc_util_report.txt
    cp $BUILD_DIR/timing_report.txt $EVAL/$DEST/img_proc_timing_report.txt
    popd
end

