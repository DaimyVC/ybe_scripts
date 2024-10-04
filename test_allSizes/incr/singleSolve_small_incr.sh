#!/bin/bash
#
#SBATCH --job-name=sss_incr
#SBATCH --time=01:00:00
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --mem-per-cpu=8G
#SBATCH --partition=zen4

diag=DIAG
size=SIZE

iup=$VSC_DATA/iup-sms-ybe/ybe-sms/build/src/ybe_sms

out=$VSC_SCRATCH/output_incr_NEW_$size

$iup -s $size --allModels --diagPart --smallerEncoding --noCommander --checkSols --noEnum --diag $diag --incr --checkFreq 100 --limCon 1 --out $out/ > $out/out_$diag.txt
	
