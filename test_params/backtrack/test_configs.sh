#!/bin/bash
#
#SBATCH --job-name=test_configs
#SBATCH --time=10:00:00
#SBATCH --array=1-15%8
#SBATCH --mem-per-cpu=8G
#SBATCH --partition=zen4
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8

module load GCCcore/12.3.0
module load Boost/1.82.0-GCC-12.3.0

configs=(""
        "--diagPart" 
        "--smallerEncoding --diagPart" 
        "--smallerEncoding --diagPart --checkSols" 
        "--smallerEncoding --diagPart --checkSols --checkFreq 5" 
        "--smallerEncoding --diagPart --checkSols --checkFreq 500" 
        "--smallerEncoding --diagPart --checkSols --checkFreq 5 --maxDepth 3"
        "--smallerEncoding --diagPart --checkSols --checkFreq 5 --maxMC 200"
        "--smallerEncoding --diagPart --checkSols --checkFreq 5 --maxBreadth 3"
        "--smallerEncoding --diagPart --checkSols --checkFreq 5 --maxDepth 7"
        "--smallerEncoding --diagPart --checkSols --checkFreq 5 --maxMC 100000"
        "--smallerEncoding --diagPart --checkSols --checkFreq 5 --maxBreadth 7"
        "--smallerEncoding --diagPart --checkSols --checkFreq 5 --maxDepth 3 --propagate"
        "--smallerEncoding --diagPart --checkSols --checkFreq 5 --maxMC 200 --propagate"
        "--smallerEncoding --diagPart --checkSols --checkFreq 5 --maxBreadth 3 --propagate"
        )

home=$(pwd)
size=9

config=${configs[$(($SLURM_ARRAY_TASK_ID-1))]}

mkdir $VSC_SCRATCH/config_test_out_${SLURM_ARRAY_TASK_ID}
out=$VSC_SCRATCH/config_test_out_${SLURM_ARRAY_TASK_ID}

iup=$VSC_DATA/iup-sms-ybe/ybe-sms/build/src/ybe_sms

$iup -s $size --allModels $config --out $out/ > $out/out_config_${SLURM_ARRAY_TASK_ID-1}.txt

