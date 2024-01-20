set NAME $argv[1]
echo Creating tables for : `$NAME`

# Throughput
python3 scripts/createThroughputTable.py results/thru_$NAME

# Latency
python3 scripts/createLatencyTable.py results/lat_$NAME

# Resources
python3 scripts/createResourceTable.py results/res_$NAME
python3 scripts/createCodesignResourceTable.py results/res_codesign_$NAME
