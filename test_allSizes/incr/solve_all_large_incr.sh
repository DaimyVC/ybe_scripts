#!/bin/bash
#SBATCH --job-name=incr10
#SBATCH --time=5-00:00:00
#SBATCH --ntasks=8
#SBATCH --mem-per-cpu=16gb
#SBATCH --partition=zen4

module load GCCcore/12.3.0
module load parallel/20230722-GCCcore-12.3.0
module load Boost/1.82.0-GCC-12.3.0

home=$(pwd)
size=10

mkdir $VSC_SCRATCH/running_scripts_incr_NEW_$size/ 
mkdir $VSC_SCRATCH/output_incr_NEW_$size/ 
scripts=$VSC_SCRATCH/running_scripts_incr_NEW_$size/

../../../iup-sms-ybe/ybe-sms/build/src/diag_maker -s $size

mv diagonals.txt diagonals_incr_${size}.txt

input="./diagonals_incr_${size}.txt"
while read -r diag
do
    sed "s/DIAG/$diag/g" $home/singleSolve_large_incr.sh > $scripts/solve_${diag}.sh
    sed -i "s/SIZE/$size/g" $scripts/solve_${diag}.sh
    chmod +x $scripts/solve_${diag}.sh
done < "$input"

parallel -j $SLURM_NTASKS --joblog joblog_solve_incr_$size.txt srun -N 1 -n 1 -c 1 --exact ::: $(ls -1 $scripts/*.sh)
wait
