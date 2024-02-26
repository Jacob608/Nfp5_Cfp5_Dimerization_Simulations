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

This workflow was designed to set up a series of all atomistic molecular dynamics simulation of two proteins with solvent and ions using Visual Molecular Dynamics to be run in NAMD. One protein has mutations systematically added to it, which are implemented using the VMD Mutator Plugin. The mutant sequences are listed in columnb B of library_44_nhalfmfps.xlsx using a single letter amino acid format, with a unique identifying code used to distinguish each sequence and simulation in column A.

## Employed Softwares with Version:

- Python version 3.6.0
- VMD version 1.9.3
- GNU Bash, version 4.2.46(2)-release (x86_64-redhat-linux-gnu)
- NAMD 3.0b3 Linux-x86_64-multicore

## Software Setup

- VMD: Visual Molecular Dynamics is a molecular visualization program for displaying, animating, and analyzing large biomolecular systems using 3-D graphics and built-in scripting. VMD supports computers running MacOS X, Unix, or Windows, is distributed free of charge, and includes source code. https://www.ks.uiuc.edu/Research/vmd/
- NAMD: NAMD is a parallel, object-oriented molecular dynamics code designed for high-performance simulation of large biomolecular systems. https://www.ks.uiuc.edu/Development/Download/download.cgi?PackageName=NAMD

## Instructions:

1. Create a conda environment from **fga_fp5.yml** in a location of your choosing using instructions found in [conda documentation]
(https://conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html#creating-an-environment-from-an-environment-yml-file).

1. Ensure all software versions being used are correct.

## File Descriptions
