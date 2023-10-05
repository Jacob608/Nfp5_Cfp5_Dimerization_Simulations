#!/bin/bash
#SBATCH --job-name="make nfp5_cfp5 PSF"
#SBATCH -A p31412
#SBATCH -p short    ## partition
#SBATCH -N 1  ## number of nodes
#SBATCH -n 1  ## number of cores
#SBATCH --output=R-%x.%j.out
#SBATCH -t 00:05:00

module purge all
module load python/anaconda3.6
module load vmd

# Organize files into an output directory.
out_dir=mutation_simulations
if [ ! -d "$out_dir" ];then
	mkdir $out_dir
else
	echo "Directory ${out_dir} already exists."
	echo "Exiting to avoid directory overwrite."
	exit
fi

# Append necessary mutations to psfgen.tcl
source activate /projects/p31412/Mfp_Brushes/envs/fga_mfp
python generate_mutator_commands.py

names=()

# Read the list of names corresponding to each sequence line by line and add each line to the array.
while IFS= read -r line; do
	names+=("$line")
done < "names.txt"

# Do some stuff for each simulation.
for element in "${names[@]}"; do
	sim_dir=$out_dir/$element
	mkdir $sim_dir
	mutant_commands=$(cat "${element}_mutator_commands.txt") # String output from generate_mutator_commands.py
	# replace_string='This line will be replaced by mutator plugin commands'
	# sed "s/${replace_string}/${mutant_commands}" < psfgen.tcl > psfgen_mutate.tcl
	cat psfgen.tcl ${element}_mutator_commands.txt > psfgen_mutate.tcl
	# Generate psf files.
	vmd -dispdev text -e psfgen_mutate.tcl >> psfgen_mutate.log
	cp view.vmd $sim_dir
	mv psfgen_mutate.tcl nfp5_cfp5* cfp5_updated_xyz.pdb ionized* psfgen_mutate.log ${element}_mutator_commands.txt $sim_dir 
	echo "$element"
done