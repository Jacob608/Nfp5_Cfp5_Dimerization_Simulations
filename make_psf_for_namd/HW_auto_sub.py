import os

start = 0
loop = 3
node_no = 1
proc_no = 52
# proc_no = 10
steps_per_sim = 1500000
# steps_per_sim = 100
name = 'simulation_name'
for i in range(start,loop):
    print(i)
    log_filename = "run_namd_"+ str(i)+ ".log"
    jobname = "nbf_"+name+"_i"+str(i)
    
    # Write submit file
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
    previous = "run" + str(i-1)
    current = "run" + str(i)    
    if i == 0:
        input_script = "run.namd"
        os.system('sed "s/run 100000000/run ' + str(steps_per_sim) + '/" ' + input_script + ' > ' + 'run_namd_0.namd')
        # os.system('sed "s/run 100000000/run 100/" ' + input_script + ' > ' + 'run_namd_0.namd')
    else:
        input_script = "run_namd_"+str(i)+".namd"
        firsttimestep = steps_per_sim*i
        os.system("cp ../template_run_namd.namd " + input_script)
        os.system('sed -i "s/PREVIOUS_RUN/' + previous + '/" ' + input_script)
        os.system('sed -i "s/CURRENT_RUN/' + current + '/" ' + input_script)
        os.system('sed -i "s/FIRST_TIMESTEP/' + str(firsttimestep) + '/" ' + input_script)
        os.system('sed -i "s/STEPS_PER_SIM/' + str(steps_per_sim) + '/" ' + input_script)

    f.write('/software/NAMD/2.13/verbs/charmrun /software/NAMD/2.13/verbs/namd2 +p' + str(proc_no) + ' run_namd_' + str(i) + '.namd > run_namd_' + str(i) + '.log')
    f.close()
    
    if i == start:
        os.system("sbatch " + filename)
    else:
        os.system("sbatch -d afterok:$(squeue --noheader --format %i --name "+last_jobname+") " + filename)
        print("sbatch -d afterok:$(squeue --noheader --format %i --name "+last_jobname+") " + filename)
        
    last_jobname = jobname
    
