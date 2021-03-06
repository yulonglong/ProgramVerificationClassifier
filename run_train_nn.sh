#!/bin/bash
# First argument is gpu number
# Second argument is gpu name

if [ -z "$1" ]
    then
        echo "Please enter gpu number as first argument!"
        exit 1
fi

if [ -z "$2" ]
    then
        echo "Please enter gpu name as second argument"
        exit 1
fi

gpu_num=$1
gpu_name=$2
theano_flags_device=gpu${gpu_num}

# Check whether gpu_name contains nscc
# If yes, do not specify GPU number in THEANO_FLAGS
# If no, specify GPU number in THEANO_FLAGS

if [[ $gpu_name == *"nscc"* ]]
    then
        theano_flags_device=gpu
fi

echo "Running script on ${theano_flags_device} : ${gpu_name}"

expt_num="02"
function_name="foo_complex"
num_parameter="4"
num_layer="2"
test_limit="10000"
train_limit="100000"
optimizer="adagrad"

THEANO_FLAGS="device=${theano_flags_device},floatX=float32,mode=FAST_RUN" python train.py \
-tr data/${function_name}_1m.out -dt ${function_name} -o expt${expt_num}-${function_name}-a${optimizer}-l${num_layer}-${gpu_name} \
-t nn --epochs 50 -a ${optimizer} -l ${num_layer} \
--active-sampling-batch 256 --active-sampling-minimum 1000 \
--num-parameter ${num_parameter} \
--train-amount-limit ${train_limit} --test-amount-limit ${test_limit} --test-size 2000
