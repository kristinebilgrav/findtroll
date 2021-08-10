import os 
import sys
from os import path

#loop through retrooutput, find positions, make interval, tabix if exists in bed file, if match add to new file with info from both files

filename = sys.argv[2] + "_tfstmp.vcf" 
fileOutput = open(sys.argv[2] + "_VEP_exons_tfs.vcf", "w")


for l in open(sys.argv[1]):
    l = l.strip("\n")
    if l.startswith("#"):
        if l.startswith("#CHROM"):
            fileOutput.write("##INFO=<ID=TFs,Number=.,Type=String,Description=\"Transcription factors\"\n")
        fileOutput.write(l + "\n")            
        continue

    linesplit  = l.split("\t")
    chro = (linesplit[0])
    position = int(linesplit[1])
    interval_start  = position - 100
    interval_stop = position + 100
    search = ( chro + ":" + str(interval_start) + "-" + str(interval_stop))
    #print("tabix /proj/nobackup/sens2017106/wharf/kbilgrav/kbilgrav-sens2017106/ENCODE/gz " + search + " " + ">" + " " + filename )
    os.system("tabix /proj/nobackup/sens2017106/wharf/kbilgrav/kbilgrav-sens2017106/ENCODE/tfs37_nochr.bed.gz " + search + " " + ">" + " " + filename ) 

    info_tag=";TFs="
    tfs = []
    for t in open(filename):
        t = t.strip("\n")
        tname = (t.split("\t"))
        tfs.append(tname[-1])

    if len(tfs) != 0:
        info_tag+= ",".join(tfs)
        linesplit[7]+= info_tag

    fileOutput.write("\t".join(linesplit) + "\n")

fileOutput.close()
