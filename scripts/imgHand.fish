argparse "n/nocompile" "c/nochar" "o/output=" -- $argv

if set -q _flag_output
    set DEST $_flag_output
else
    set DEST results/res
end

echo Writing results to `$DEST`
mkdir -p $DEST

set EVAL $ROOT/evaluation

set proj src/imgHandwritten 
pushd $proj

# Compile
if not set -q _flag_nocompile
sbt 'run ZedBoard'
end

# Do characterization
if not set -q _flag_nochar
    set BUILD_DIR results_ZedBoardWrapper.v
    cd build
    # Run OMX
    $OHMYXILINX/vivadocompile.sh ZedBoardWrapper.v clock xc7z020clg484-1
    # Copy results back
    cp $BUILD_DIR/res.txt $EVAL/$DEST/img_hand.txt
    cp $BUILD_DIR/util_report.txt $EVAL/$DEST/img_hand_util_report.txt
    cp $BUILD_DIR/timing_report.txt $EVAL/$DEST/img_hand_timing_report.txt
end
popd