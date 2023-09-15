#!/usr/bin/env python
# coding: utf-8

# Jacob Graham
# Sinan Keten's Computational Nanodynamics Laboratory

import pandas as pd
print(pd.__version__)
df = pd.read_excel('library_44_nhalfmfps.xlsx', sheet_name='For Simulations')

wt_seq = 'SEEYKGGYYPGNTYHYHSGGSYHGSGYHGGYKGKYY' # Single letter amino acid code for wild type Nfp5 sequence.

amino_acid_codes = {'A':'ALA', 
                    'R':'ARG', 
                    'N':'ASN',
                    'D':'ASP',
                    'C':'CYS',
                    'Q':'GLN',
                    'E':'GLU',
                    'G':'GLY',
                    'H':'HSE',
                    'I':'ILE',
                    'L':'LEU',
                    'K':'LYS',
                    'M':'MET',
                    'F':'PHE',
                    'P':'PRO',
                    'S':'SER',
                    'T':'THR',
                    'W':'TRP',
                    'Y':'TYR',
                    'V':'VAL'}


names_file = open(f"names.txt", "w")
for ind in df.index:
    mut_seq = df['Sequence'][ind]
    name = df['Name'][ind]
    names_file.write(f"{name}\n")
    mut_file = open(f"{name}_mutator_commands.txt", "w")
    mut_file.write(f"# Mutant sequence: {mut_seq}")
    for a in range(len(wt_seq)):
        if wt_seq[a] != mut_seq[a]:
            mut_message=f'{name}: Identified mutation of {wt_seq[a]} to {mut_seq[a]} at in residue number {a+1}.'
            mut_file.write(f"# {mut_message} \n")
            # Convert single letter amino acid code to three letter amino acid code for VMD Mutator Plugin.
            mut_resname = ''.join([amino_acid_codes[aa] for aa in mut_seq[a]])
            mut_file.write(f"mutator -psf ionized.psf -pdb ionized.pdb -o mutant_{name} -ressegname U -resid {a+1} -mut {mut_resname} \n")
    mut_file.close()
names_file.close()



