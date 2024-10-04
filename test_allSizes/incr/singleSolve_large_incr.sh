#!/bin/bash
#
#SBATCH --job-name=ss_incr
#SBATCH --time=120:00:00
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --mem-per-cpu=32G
#SBATCH --partition=zen4
diag=DIAG
size=SIZE

iup=$VSC_DATA/iup-sms-ybe/ybe-sms/build/src/ybe_sms

out=$VSC_SCRATCH/output_incr_NEW_$size

$iup -s $size --allModels --diagPart --smallerEncoding --noCommander --noEnum --diag $diag --incr --limCon 1 --checkFreq 100 --checkSols --out $out/ > $out/out_$diag.txt
	
