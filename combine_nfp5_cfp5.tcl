package require psfgen

resetpsf

mol new nfp5.pdb
mol new cfp5.pdb

set selNfp5 [atomselect 0 "segid U"]
set selCfp5 [atomselect 1 "segid U"]
#https://www.researchgate.net/post/How_can_I_calculate_center_of_mass_for_a_protein
set selNcenter [measure center $selNfp5 weight mass] 
set selCcenter [measure center $selCfp5 weight mass]

# Get the distance between selNcenter and selCcenter

set delimiter " "
set valueListN [split $selNcenter $delimiter]
set Nx [lindex $valueListN 0]
set Ny [lindex $valueListN 1]
set Nz [lindex $valueListN 2]

set valueListC [split $selCcenter $delimiter]
set Cx [lindex $valueListC 0]
set Cy [lindex $valueListC 1]
set Cz [lindex $valueListC 2]

set dx [expr {$Cx - $Nx}]
set dy [expr {$Cy - $Ny}]
set dz [expr {$Cz - $Nz}]

set distance [expr {sqrt($dx*$dx + $dy*$dy + $dz*$dz)}]

set ux [expr {$dx / $distance}]
set uy [expr {$dy / $distance}]
set uz [expr {$dz / $distance}]

# desired_d is the desired distance between the center of mass of nfp5.pdb and cfp5.pdb
set desired_d 30

set translation [expr {$distance - $desired_d}]

set shiftx [expr {-double($translation * $ux)}]
set shifty [expr {-double($translation * $uy)}]
set shiftz [expr {-double($translation * $uz)}]

# https://www.ks.uiuc.edu/Research/vmd/mailing_list/vmd-l/8328.html

$selCfp5 moveby [format "%.3f %.3f %.3f" $shiftx $shifty $shiftz]

$selCfp5 writepdb cfp5_updated_xyz.pdb

topology top_all36_prot_NBFIX.rtf
topology run_simulation/toppar_water_ions.str

alias residue HIS HSE

segment U {pdb nfp5.pdb}
coordpdb nfp5.pdb U
guesscoord

segment V {pdb cfp5_updated_xyz.pdb}
coordpdb cfp5_updated_xyz.pdb V
guesscoord

writepdb nfp5_cfp5.pdb
writepsf nfp5_cfp5.psf

exit
