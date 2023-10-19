#!/bin/bash
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

# Generate a simulation with no mutations

mkdir $out_dir/no_mutation
vmd -dispdev text -e combine_nfp5_cfp5.tcl >> combine_nfp5_cfp5.log
vmd -dispdev text -e solvate_ionize.tcl >> solvate_ionize.log
cp view.vmd $out_dir/no_mutation
mv nfp5_cfp5* ionized* solvate_ionize.log combine_nfp5_cfp5.log $out_dir/no_mutation

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

	vmd -dispdev text -e combine_nfp5_cfp5.tcl >> combine_nfp5_cfp5.log

	mutant_commands=$(cat "${element}_mutator_commands.txt") # String output from generate_mutator_commands.py
	# replace_string='This line will be replaced by mutator plugin commands'
	# sed "s/${replace_string}/${mutant_commands}" < psfgen.tcl > psfgen_mutate.tcl
	cat mutate.tcl ${element}_mutator_commands.txt > ${element}_mutate.tcl
	# Generate psf files.
	vmd -dispdev text -e ${element}_mutate.tcl >> ${element}_mutate.log
	vmd -dispdev text -e solvate_ionize.tcl >> solvate_ionize.log

	cp view.vmd $sim_dir
	mv solvate_ionize.log combine_nfp5_cfp5.log nfp5_cfp5* cfp5_updated_xyz.pdb ionized* ${element}* $sim_dir 
	echo "$element"
done
