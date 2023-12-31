#!/bin/bash
#SBATCH --job-name="jobname"
#SBATCH -A p31412
#SBATCH -p long    ## partition
#SBATCH -N 1  ## number of nodes
#SBATCH --ntasks-per-node=52  ## number of cores
#SBATCH -t 100:00:00

#https://researchcomputing.princeton.edu/support/knowledge-base/namd
module purge all
module load namd

/software/NAMD/2.13/verbs/charmrun /software/NAMD/2.13/verbs/namd2 +p52 run.namd > run_namd.log