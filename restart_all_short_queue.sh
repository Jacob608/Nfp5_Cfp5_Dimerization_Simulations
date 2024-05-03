# Load necessary modules.
module load python/anaconda3.6

# Load all the simulation names stored in file names.txt into the list names.
names=()
while IFS= read -r line; do
	names+=("$line")
done < "names.txt"

# For each element in names, navigate into that directory, copy auto_submit_restart_short_queue.py into that directory, replace 'simulation name' with the element in auto_submit_restart_short_queue.py and run auto_submit_restart_short_queue.py.
for element in "${names[@]}"; do
	cd $element
	cp ../auto_submit_restart_short_queue.py .
	sed -i "s/simulation_name/${element}/" auto_submit_restart_short_queue.py
	python auto_submit_restart_short_queue.py
	cd ..
done
