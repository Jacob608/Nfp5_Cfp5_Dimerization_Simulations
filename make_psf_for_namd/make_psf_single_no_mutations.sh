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

# Generate solvated and ionized PSF in VMD.
module load vmd
vmd -dispdev text -e psfgen.tcl >> psfgen.log

out_dir=psfgen_no_mutation_out
if [ ! -d "$out_dir" ];then
	mkdir $out_dir
    mv nfp5_cfp5* cfp5_updated_xyz.pdb psfgen.log ionized* $out_dir
    cp view.vmd $out_dir
else
	echo "Directory ${out_dir} already exists."
	exit
fi