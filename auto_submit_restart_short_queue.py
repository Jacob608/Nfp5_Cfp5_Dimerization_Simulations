# Import necessary libraries.
import os

# Specify how many short queue simulations will be submitted by setting start and loop variables.
start = 0
loop = 134

# Set the number of nodes and processesors to be requested in each short queue simulation.
node_no = 1
proc_no = 52

# Set the number of MD steps to be executed by the run command in each simulation.
steps_per_sim = 1500000
# steps_per_sim = 100

# Specify the name of this simulation by setting the variable name.
name = 'simulation_name'

# Run through a loop to set up each short queue simulation.
for i in range(start,loop):
    print(i)

    # Set variables to specify namd log file name and job name.
    log_filename = "run_namd_"+ str(i)+ ".log"
    jobname = "nbf_"+name+"_i"+str(i)
    
    # Write the submit file, named with variable filename, line by line.
    filename = "run_namd_"+ str(i) +".sh"
    f = open(filename, "w")
    f.write('#!/bin/bash\n')
    f.write('#SBATCH -A p31412\n')
    f.write('#SBATCH -p short\n')
    f.write('#SBATCH -N '+str(node_no)+'\n')
    f.write('#SBATCH --ntasks-per-node='+str(proc_no)+'\n')
    f.write('#SBATCH -t 3:59:38\n')
    # f.write('#SBATCH -t 00:04:38\n')
    f.write('#SBATCH --job-name="'+jobname+'"\n\n')
    
    # f.write('cd $SLURM_SUBMIT_DIR\n')
    f.write('#https://researchcomputing.princeton.edu/support/knowledge-base/namd')
    f.write('module purge all\n')
    f.write('module load namd\n')
    f.write('/software/NAMD/2.13/verbs/charmrun /software/NAMD/2.13/verbs/namd2 +p' + str(proc_no) + ' run_namd_' + str(i) + '.namd > run_namd_' + str(i) + '.log')
    f.close()
    
    # Make some changes to the template namd run file.
    previous = "run" + str(i-1) # Use previous variable to refer to necessary files from previous simulation.
    current = "run" + str(i)    # Use the current variable to refer to files to be output from the current simulation.

    # For edge case i = 0, there is no previous run, so simply copy file run.namd as run_namd_0.namd.
    if i == 0:
        input_script = "run.namd"
        os.system('sed "s/run 100000000/run ' + str(steps_per_sim) + '/" ' + input_script + ' > ' + 'run_namd_0.namd')
        # os.system('sed "s/run 100000000/run 100/" ' + input_script + ' > ' + 'run_namd_0.namd')
    
    # Otherwise, make a copy of template_run_namd.namd as run_namd_str(i).namd and use the sed command to set some variables.
    else:
        input_script = "run_namd_"+str(i)+".namd"
        firsttimestep = steps_per_sim*i
        os.system("cp ../template_run_namd.namd " + input_script)
        os.system('sed -i "s/PREVIOUS_RUN/' + previous + '/" ' + input_script)
        os.system('sed -i "s/CURRENT_RUN/' + current + '/" ' + input_script)
        os.system('sed -i "s/FIRST_TIMESTEP/' + str(firsttimestep) + '/" ' + input_script)
        os.system('sed -i "s/STEPS_PER_SIM/' + str(steps_per_sim) + '/" ' + input_script)

    # Submit this simulation using the sbatch command.
    # For edge case i = 0, submit run_namd_0.sh.
    if i == start:
        os.system("sbatch " + filename)
        
    # After the template_run_namd.namd file has been copied and edited, submit this simulation with a dependency that the last simulation, specified by its job name, must finish before this one starts.
    else:
        os.system("sbatch -d afterok:$(squeue --noheader --format %i --name "+last_jobname+") " + filename)
        print("sbatch -d afterok:$(squeue --noheader --format %i --name "+last_jobname+") " + filename)
        
    # Set last_jobname for the next run.    
    last_jobname = jobname
    
