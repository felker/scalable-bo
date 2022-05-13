#!/bin/bash
export RANKS_PER_NODE=8
export acq_func="qUCB"
export strategy="qUCB"
export timeout=120
export random_state=42 
export problem="fast_ackley_2"
export sync_val=0
export search="DBO"

if [[ "$sync_val" -eq 0 ]];
then
  export sync_str="async"
else
  export sync_str="sync"
fi

# CBO
export log_dir="output/$problem-$search-$sync_str-$acq_func-$strategy-1-$RANKS_PER_NODE-$timeout-$random_state";

echo "Running: mpirun -np $RANKS_PER_NODE python -m scalbo.exp --problem $problem \
--search $search \
--sync $sync_val \
--timeout $timeout \
--acq-func $acq_func \
--strategy $strategy \
--random-state $random_state \
--log-dir $log_dir \
--n-jobs 1 \
--verbose 1";

mpirun -np $RANKS_PER_NODE python -m scalbo.exp --problem $problem \
    --search $search \
    --sync $sync_val \
    --timeout $timeout \
    --acq-func $acq_func \
    --strategy $strategy \
    --random-state $random_state \
    --log-dir $log_dir \
    --n-jobs 1 \
    --verbose 1
    
