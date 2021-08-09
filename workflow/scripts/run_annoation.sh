#!/bin/bash -l
#SBATCH -A sens2017106
#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 7-00:00:00
#SBATCH -J tabix_annotate

module load bioinfo-tools tabix

#python /proj/nobackup/sens2017106/kristine/SVDB/find_exons.py
python /proj/nobackup/sens2017106/kristine/SVDB/find_tfs.py $1 /proj/nobackup/sens2017106/kristine/SVDB/$2/$2
python /proj/nobackup/sens2017106/kristine/SVDB/find_segdups.py /proj/nobackup/sens2017106/kristine/SVDB/$2/$2_VEP_exons_tfs.vcf  /proj/nobackup/sens2017106/kristine/SVDB/$2/$2
python /proj/nobackup/sens2017106/kristine/SVDB/find_DNase.py /proj/nobackup/sens2017106/kristine/SVDB/$2/$2_VEP_exons_tfs_segdup.vcf /proj/nobackup/sens2017106/kristine/SVDB/$2/$2

#mv $2_*  /proj/nobackup/sens2017106/kristine/SVDB/$2
