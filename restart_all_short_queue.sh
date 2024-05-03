module load python/anaconda3.6
names=()
while IFS= read -r line; do
	names+=("$line")
done < "names.txt"

for element in "${names[@]}"; do
	cd $element
	cp ../auto_submit_restart_short_queue.py .
	sed -i "s/simulation_name/${element}/" auto_submit_restart_short_queue.py
	python auto_submit_restart_short_queue.py
	cd ..
done
