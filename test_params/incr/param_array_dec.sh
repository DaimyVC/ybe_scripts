#!/bin/bash
#
#SBATCH --job-name=param_dec_9
#SBATCH --time=24:00:00
#SBATCH --array=1-36%16
#SBATCH --mem-per-cpu=16G
#SBATCH -n 4
#SBATCH --partition=zen4

module load GCCcore/12.3.0
module load parallel/20230722-GCCcore-12.3.0
module load Boost/1.82.0-GCC-12.3.0

depths=(1 10 100 1000 10000 100000)
freqs=(1 10 100 1000 10000 100000)

home=$(pwd)
size=9

freq=${freqs[$((($SLURM_ARRAY_TASK_ID-1) / 6))]}
depth=${depths[$((($SLURM_ARRAY_TASK_ID-1) % 6))]}

mkdir $VSC_SCRATCH/param_dec_${size}/param_dec_${size}_${depth}_${freq}/ 
out=$VSC_SCRATCH/param_dec_${size}/param_dec_${size}_${depth}_${freq}

iup=$VSC_DATA/iup-sms-ybe/ybe-sms/build/src/ybe_sms

$iup -s $size --allModels --diagPart --smallerEncoding --noCommander --checkSols --checkFreq $freq --limDec $depth --incr --noEnum --out $out/ > $out/out_dec_$size.txt
