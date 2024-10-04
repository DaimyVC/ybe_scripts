#!/bin/bash
#
#SBATCH --job-name=single_solve
#SBATCH --time=01:00:00
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --mem-per-cpu=8G
#SBATCH --partition=zen4

diag=DIAG
size=SIZE

iup=$VSC_DATA/iup-sms-ybe/ybe-sms/build/src/ybe_sms

out=$VSC_SCRATCH/outputSmall_$size

$iup -s $size --allModels --diagPart --smallerEncoding --checkSols --checkFreq 5 --maxMC 200 --propagate --noCommander --diag $diag --out $out/ > $out/out_$diag.txt
	
