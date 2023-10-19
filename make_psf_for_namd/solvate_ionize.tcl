package require solvate
package require autoionize

mol new nfp5_cfp5.psf
mol addfile nfp5_cfp5.pdb

solvate nfp5_cfp5.psf nfp5_cfp5.pdb -t 12 -o nfp5_cfp5_solvated

autoionize -psf nfp5_cfp5_solvated.psf -pdb nfp5_cfp5_solvated.pdb -sc 0.15 -cation SOD -anion CLA

exit