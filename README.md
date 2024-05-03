<!-- For developers:
Please use bold font for file names, directories, and file paths.
Please use italic font for variables.
Follow heading styles.
# First-level heading
## Second-level heading
### Third-level heading
See https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax for formatting syntax.
-->

# Nfp5_Cfp5_Dimerization_Simulations

This workflow was designed to set up a series of all atomistic molecular dynamics simulation of two proteins with solvent and ions using Visual Molecular Dynamics to be run in NAMD. One protein has mutations systematically added to it, which are implemented using the VMD Mutator Plugin. The mutant sequences are listed in column B of library_44_nhalfmfps.xlsx using a single letter amino acid format, with a unique identifying code used to distinguish each sequence and simulation in column A.

## Employed Softwares with Version:

- Python version 3.6.0
- VMD version 1.9.3
- GNU Bash, version 4.2.46(2)-release (x86_64-redhat-linux-gnu)
- NAMD 3.0b3 Linux-x86_64-multicore
- TCL version 8.6

## Software Setup

- VMD: Visual Molecular Dynamics is a molecular visualization program for displaying, animating, and analyzing large biomolecular systems using 3-D graphics and built-in scripting. VMD supports computers running MacOS X, Unix, or Windows, is distributed free of charge, and includes source code. https://www.ks.uiuc.edu/Research/vmd/
- NAMD: NAMD is a parallel, object-oriented molecular dynamics code designed for high-performance simulation of large biomolecular systems. https://www.ks.uiuc.edu/Development/Download/download.cgi?PackageName=NAMD

## File Descriptions:

### In the main directory **Nfp5_Cfp5_Dimerization_Simulations**

- **make_psf_multi_mutations.sh** - Bash script which can be run using the command 'bash **make_psf_multi_mutations.sh**' to execute the entire workflow for generating simulations.
- **combine_nfp5_cfp5.tcl** - Script of tcl commands to be run in VMD to position the center of masses of the structures in **nfp5.pdb** and **cfp5.pdb** within a reasonable distance of each other.
- **nfp5.pdb** - A protein data bank file containing a structure of the N-half of mussel foot protein 5 as it is defined in [this paper](https://doi.org/10.1038/s41467-023-37563-0). This structure was obtained through a simple equilibration of the soluble protein in 150 mmol NaCl using LAMMPS in an NPT ensemble.
- **cfp5.pdb** - A protein data bank file containing a structure of the C-half of mussel foot protein 5 as it is defined in [this paper](https://doi.org/10.1038/s41467-023-37563-0). This structure was obtained through a simple equilibration of the soluble protein in 150 mmol NaCl using LAMMPS in an NPT ensemble.
- **solvate_ionize.tcl** - A tcl script to be run in VMD which adds solvate and ions to the structure **nfp5_cfp5.pdb/nfp5_cfp5.psf** output by running **combine_nfp5_cfp5.tcl**. The output of **solvate_ionize.tcl** is **nfp5_cfp5_solvated.psf** and **nfp5_cfp5_solvated.pdb**.
- **view_traj.vmd** - A VMD file using tcl language to automatically view the structure and trajectory of an example simulation. Run using the command 'source **view_traj.vmd**' on the VMD command line.
- **generate_mutator_commands.py** - A python script that reads the sequences in **library_feb24_max_distance.xlsx** and automatically generates a list of tcl commands which utilize the VMD Mutator Plugin to introduce mutations from the wild type sequence for nfp5 to the structure **nfp5_cfp5.pdb/nfp5_cfp5.psf**.
- **libraryfeb24_max_distance.xlsx** - An excel spreadsheet containing a list of mutated sequencse of nfp5 paired with a unique identifier for that simulation.
- **fga_fp5.yml** - A conda yml file that can be used to make a conda environment compatible with the **make_psf_multi_mutations.sh**.
- **top_all36_prot_NBFIX.rtf** - A topology file for all atomistic molecular dynamics representations of proteins with atom types updated for compatibility with the nonbonded fix for cation-pi interactions introduced in [Liu et al. JCTC 2021](https://doi.org/10.1021/acs.jctc.1c00219). This file was originally downloaded from the [MacKerell Lab homepage](https://mackerell.umaryland.edu/charmm_ff.shtml#charmm) before being updated manually to include topology changes to tyrosine and arginine for the nonbonded fix.
- **mutate.tcl** - A tcl script acting as a starting template for running the VMD Mutator Plugin in VMD. Commands compatible with the VMD Mutator Plugin are appended by **generate_mutator_commands.py** for each simulation.
- **get_NAMDenergy.vmd** -
- **get_NAMDenergy_all_simulations.sh** -
- **organize_NAMD_energy_files.sh** -

### In the subdirectory **run_simulation**
- **maxmin_new.tcl** - A tcl script written by L. Martinez to get the maximum and minimum coordinates in the x, y, and z directions of a pdb file. Since NAMD requires an initial approximation for the edge of initial periodic boundaries of a simulation, these coordinates are then used to print 'cellBasisVector' commands which are copied and pasted into the file **run.namd**. For additional usage and implementation of **maxmin_new.tcl**, see [this YouTube video](https://www.youtube.com/watch?v=IArpsQsZ95U).
- **run.namd** - A NAMD simulation script to run an equilibration at temperature 300 K and pressure 1.02 atm. with Langevin temperature and pressure controls.
- **toppar_water_ions.str** - A stream file containing the topology and parameters necessary to simulate all atomistic representations of water and ions compatible with the CHARMM force field. The latest version and previous versions of this file can be downloaded from the [MacKerell Lab homepage](https://mackerell.umaryland.edu/charmm_ff.shtml#charmm).
- **run_namd.sh** - A bash script containing the command to execute the namd configuration file **run.namd** and suitable slurm commands (lines beginning with '#SBATCH') to run a paralellized NAMD simulation on [Northwester University's Quest High-Performance Computing Cluster](https://www.it.northwestern.edu/departments/it-services-support/research/computing/quest/).
- **charmm36.cmap** - A cmap file containing force field corrections to the CHARMM36 pairwise additive force field.
- **ARG.prm** - Parameters for the amino acid arginine, to be modeled with a nonbonded fix for cation-pi interactions obtained from [Liu et al. JCTC 2021](https://doi.org/10.1021/acs.jctc.1c00219). This file was originally downloaded from the supplementary information in [Liu et al. JCTC 2021](https://doi.org/10.1021/acs.jctc.1c00219).
- **TYR.prm** - Parameters for the amino acid tyrosine, to be modeled with a nonbonded fix for cation-pi interactions obtained from [Liu et al. JCTC 2021](https://doi.org/10.1021/acs.jctc.1c00219). This file was originally downloaded from the supplementary information in [Liu et al. JCTC 2021](https://doi.org/10.1021/acs.jctc.1c00219).
- **par_all36_cgenff_NBFIX.prm** - Parameter file containing parameters to implement the CHARMM general force field compatible with the nonbonded fix presented in [Liu et al. JCTC 2021](https://doi.org/10.1021/acs.jctc.1c00219). This file was originally downloaded from the supplementary information in [Liu et al. JCTC 2021](https://doi.org/10.1021/acs.jctc.1c00219).
- **par_all36m_prot_NBFIX.prm** - Parameter file containing parameters to implement the CHARMM force field for proteins compatible with the nonbonded fix presented in [Liu et al. JCTC 2021](https://doi.org/10.1021/acs.jctc.1c00219). This file was originally downloaded from the supplementary information in [Liu et al. JCTC 2021](https://doi.org/10.1021/acs.jctc.1c00219).


## Instructions:

### Generate and Run Simulations

1. Create a conda environment from **fga_fp5.yml** in a location of your choosing using instructions found in [conda documentation](https://conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html#creating-an-environment-from-an-environment-yml-file).

1. Ensure all software versions being used are correct.

1. The file **make_psf_multi_mutations.sh** contains all the bash commands necessary to build all mutated simulations specified in **libraryfeb24_max_distance.xlsx**. Change the conda command 'source activate /home/jjg9482/anaconda3/envs/fga_mfp' to specify the path to your newly created conda environment. Change the sbatch submission script **run_simulation/run_namd.sh** to reflect the location of your NAMD software. If you would like to use a different excel spreadsheet with your own sequences, change the command "df = pd.read_excel('libraryfeb24_max_distance.xlsx', sheet_name='For Simulations')" corresponding to the name of your excel spreadsheet in .xlsx format. Make sure that your sequence names and the sequences themselves are formatted the same as they are in the file **libraryfeb24_max_distance.xlsx**. Run this script using the command "bash **make_psf_multi_mutations.sh** > make_psf_multi_mutations_output.txt".

1. The files for running each individual simulation are sorted into subdirectories within the directory **mutation_simulations_NBFIX**. Each subdirectory is named for each mutation's unique identifying code. Each simulation can be run by simply executing NAMD with the command found in that directory's instance of **run_namd.sh**.

### Analyze Simulations

1. Copy **get_NAMDenergy_all_simulations.sh** and **get_NAMDenergy.vmd** into the directory **mutation_simulations_NBFIX**.

2. Run the bash script **get_NAMDenergy_all_simulations.sh** by submitting as a job to a slurm job scheduler with the sbatch command or directly from the command line using the bash command.
