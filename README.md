# findtroll
TE identification, with annotation from VEP and exons, TFs, SegDups, DNase.

BAM file

Jitterbug  RetroSeq

TIDDIT
MobileAnn

SVDB (merge)

VEP
Biomart
Tablebrowser

run with: positional arguments: workflowfile

optional arguments: -h, --help show this help message and exit --folder FOLDER input a folder with samples to run --sample SAMPLE input a sample to run --use-singularity -n, --dry-run --target TARGET specify which rule(s) to run

ex: python run config/config.yaml --folder samples
