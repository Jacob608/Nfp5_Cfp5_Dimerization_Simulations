#!/bin/bash
#SBATCH --job-name="Collect NAMD Energy"
#SBATCH -A p31412
#SBATCH -p short    ## partition
#SBATCH -N 1  ## number of nodes
#SBATCH --ntasks-per-node=1  ## number of cores
#SBATCH -t 4:00:00

# Load necessary modules.
module load vmd

# Load all the simulation names stored in file names.txt into the list names.
names=()
while IFS= read -r line; do
	names+=("$line")
done < "names.txt"

# For each element in list names, change
for element in "${names[@]}"; do
	cd $element
	cp namdenergy.csv namdenergy_$element.csv
	mv namdenergy_$element.csv ../all_namd_energies
	cd ..
done
