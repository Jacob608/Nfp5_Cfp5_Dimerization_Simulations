#!/bin/bash
module purge all
module load python/anaconda3.6
module load vmd

#----- Make a directory into which files will be organized.
out_dir=mutation_simulations_NBFIX
if [ ! -d "$out_dir" ];then
	mkdir $out_dir
else # If a directory by the name $out_dir already exists, exit with message.
	echo "Directory ${out_dir} already exists."
	echo "Exiting to avoid directory overwrite."
	exit
fi

#----- Generate a simulation with no mutations.

mkdir $out_dir/no_mutation # Make a directory to organize output files.
vmd -dispdev text -e combine_nfp5_cfp5.tcl >> combine_nfp5_cfp5.log # Use VMD to position the two proteins next to each other in the same pdb/psf.
vmd -dispdev text -e solvate_ionize.tcl >> solvate_ionize.log # Use VMD to add solvent and ions.
cp view_traj.vmd $out_dir/no_mutation # Copy view_traj.vmd into output directory.
mv nfp5_cfp5* ionized* solvate_ionize.log combine_nfp5_cfp5.log $out_dir/no_mutation # Organize files into the output directory.
cp ../run_simulation/* $out_dir/no_mutation
cd $out_dir/no_mutation
tclsh maxmin_new.tcl # Run maxmin_new.tcl to get periodic boundary conditions for NAMD simulation
pbc_namd_commands=$(cat pbc_namd_commands.txt) # String output from generate_mutator_commands.py
sed -i "s/-pbc commands here-/$pbc_namd_commands/g" run.namd # Add cellBasisVector commands to run.namd
cd ../..

#----- Make simulations with one protein mutated.
source activate /projects/p31412/Mfp_Brushes/envs/fga_mfp # Activate a conda environment with Python version 3.6.0
python generate_mutator_commands.py # Run generate_mutator_commands.py

# Read the list of names corresponding to each sequence line by line and add each line to the array.
names=()
while IFS= read -r line; do
	names+=("$line")
done < "names.txt"
mv names.txt submit_all.sh $out_dir
# Generate each simulation.
for element in "${names[@]}"; do
	sim_dir=$out_dir/$element 
	mkdir $sim_dir # Make a directory to organize output files.

	vmd -dispdev text -e combine_nfp5_cfp5.tcl >> combine_nfp5_cfp5.log # Use VMD to position the two proteins next to each other in the same pdb/psf.

	cat mutate.tcl ${element}_mutator_commands.txt > ${element}_mutate.tcl # Concatenate the VMD Mutator Plugin commands to the end of ${element}_mutator_commands.txt and save the output file as ${element}_mutate.tcl

	vmd -dispdev text -e ${element}_mutate.tcl >> ${element}_mutate.log # Add mutations using VMD.
	vmd -dispdev text -e solvate_ionize.tcl >> solvate_ionize.log # Use VMD to add solvent and ions.

	cp view_traj.vmd $sim_dir # Copy view_traj.vmd into output directory.
	mv solvate_ionize.log combine_nfp5_cfp5.log nfp5_cfp5* cfp5_updated_xyz.pdb ionized* ${element}* $sim_dir # Organize files into the output directory.

	cp ../run_simulation/* $sim_dir # Copy all files in directory run_simulation into output directory.
	cd $sim_dir
	tclsh maxmin_new.tcl # Run maxmin_new.tcl to get periodic boundary conditions for NAMD simulation
	pbc_namd_commands=$(cat pbc_namd_commands.txt) # String output from generate_mutator_commands.py
	sed -i "s/-pbc commands here-/$pbc_namd_commands/g" run.namd # Add cellBasisVector commands to run.namd
	sed -i "s/jobname/$element/g" run_namd.sh # Change job name to unique identifier in run_namd.sh
	cd ../..
done
