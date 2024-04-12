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
done < "names_successful_sims_only.txt"

for element in "${names[@]}"; do
	cd $element
	cp namdenergy.csv namdenergy_$element.csv
	mv namdenergy_$element.csv ../all_namd_energies
	cd ..
done