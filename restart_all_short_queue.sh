module load python/anaconda3.6
names=()
while IFS= read -r line; do
	names+=("$line")
done < "names.txt"

for element in "${names[@]}"; do
	cd $element
	cp ../HW_auto_sub.py .
	sed -i "s/simulation_name/${element}/" HW_auto_sub.py
	python HW_auto_sub.py
	cd ..
done