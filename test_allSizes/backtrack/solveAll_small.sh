#!/bin/bash
#SBATCH --job-name=solve_9
#SBATCH --time=01:00:00
#SBATCH --ntasks=8
#SBATCH --mem-per-cpu=8gb
#SBATCH --partition=zen4

module load GCCcore/12.3.0
module load parallel/20230722-GCCcore-12.3.0
module load Boost/1.82.0-GCC-12.3.0

home=$(pwd)
size=9

mkdir $VSC_SCRATCH/running_scriptsSmall_$size/ 
mkdir $VSC_SCRATCH/outputSmall_$size/ 
scripts=$VSC_SCRATCH/running_scriptsSmall_$size/

../../iup-sms-ybe/ybe-sms/build/src/diag_maker -s $size

mv diagonals.txt diagonals_${size}.txt

input="./diagonals_${size}.txt"
while read -r diag
do
    sed "s/DIAG/$diag/g" $home/singleSolve_small.sh > $scripts/solve_${diag}.sh
    sed -i "s/SIZE/$size/g" $scripts/solve_${diag}.sh
    chmod +x $scripts/solve_${diag}.sh
done < "$input"

parallel --delay 0.2 -j $SLURM_NTASKS --joblog joblog_solve_$size.txt --resume srun --time=01:00:00 -N 1 -n 1 -c 1 --exact ::: $(ls -1 $scripts/*.sh)
wait
