#!/bin/bash -l
#SBATCH -A sens2017106
#SBATCH -p core
#SBATCH -n 3
#SBATCH -t 7-00:00:00
#SBATCH -J TROLL_RUN

source /home/kbilgrav/anaconda3/bin/activate

module load bioinfo-tools python3 snakemake samtools

#convert cram to bam
#cp $1 $TMPDIR/$2.cram
#samtools view -b -h -T /sw/data/uppnex/ToolBox/hg38bundle/Homo_sapiens_assembly38.fasta  $TMPDIR/$2.cram >  $TMPDIR/$2.bam
#samtools index  $TMPDIR/$2.bam
#cp $TMPDIR/$2.bam /proj/nobackup/sens2017106/wharf/kbilgrav/kbilgrav-sens2017106/findtroll


python3 run config/config.yaml --sample $PWD/$1.bam --use-singularity

