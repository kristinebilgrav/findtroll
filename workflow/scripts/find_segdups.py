import os 
import sys
from os import path

#loop through retrooutput, find positions, make interval, tabix if exists in bed file, if match add to new file with info from both files

filename = sys.argv[3] + "_segduptmp.vcf" 
fileOutput = open(sys.argv[3] + "_VEP_exons_tfs_segdup.vcf", "w")


for l in open(sys.argv[1]):
    l = l.strip("\n")
    if l.startswith("#"):
        if l.startswith("#CHROM"):
            fileOutput.write("##INFO=<ID=SegDup,Number=.,Type=String,Description=\"Segmental Duplication\"\n")
        fileOutput.write(l + "\n")            
        continue

    linesplit  = l.split("\t")
    chro = (linesplit[0])
    position = int(linesplit[1])
    interval_start  = position - 100
    interval_stop = position + 100
    search = ( chro + ":" + str(interval_start) + "-" + str(interval_stop))
    os.system("tabix " + sys.argv[2] + " " + search + " " + ">" + " " + filename ) 

    info_tag=";SegDup="
    var = []
    for t in open(filename):
        t = t.strip("\n")
        tname = (t.split("\t"))
        var.append(tname[3])


    if len(var) != 0:
        info_tag+= ",".join(var)
        linesplit[7]+= info_tag

    fileOutput.write("\t".join(linesplit) + "\n")

fileOutput.close()
os.system('rm ' + filename)
