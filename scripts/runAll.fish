set NAME $argv[1]
echo Running test: `$NAME`

set EVAL $ROOT/evaluation

# Throughput
source $EVAL/scripts/throughput.fish -o results/thru_$NAME
python3 scripts/createThroughputTable.py results/thru_$NAME

# Latency
source $EVAL/scripts/latency.fish -o results/lat_$NAME
python3 scripts/createLatencyTable.py results/lat_$NAME

# Resources
source $EVAL/scripts/resource.fish -o results/res_$NAME
python3 scripts/createResourceTable.py results/res_$NAME

# Codesign Resources
source $EVAL/scripts/codesignResource.fish -o results/res_codesign_$NAME
python3 scripts/createCodesignResourceTable.py results/res_codesign_$NAME
