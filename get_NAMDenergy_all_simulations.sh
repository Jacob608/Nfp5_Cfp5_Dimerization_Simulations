#!/bin/bash
#SBATCH --job-name="Collect NAMD Energy"
#SBATCH -A p31412
#SBATCH -p short    ## partition
#SBATCH -N 1  ## number of nodes
#SBATCH --ntasks-per-node=1  ## number of cores
#SBATCH -t 4:00:00

module load vmd
names=()
while IFS= read -r line; do
	names+=("$line")
done < "names.txt"

for element in "${names[@]}"; do
	cd $element
	cp ../get_NAMDenergy.vmd .
	vmd -dispdev text -e get_NAMDenergy.vmd >> get_NAMDenergy.log
	cd ..
done
