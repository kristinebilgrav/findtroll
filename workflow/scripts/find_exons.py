import os 
import sys
from os import path

#loop through retrooutput, find positions, make interval, tabix if exists in bed file, if match add to new file with info from both files

fileOutput = open(sys.argv[3] + "_VEP_exons.vcf", "w")
filename = sys.argv[3] + "_exonstmp.vcf" 


for l in open(sys.argv[1]):
    l = l.strip("\n")
    if l.startswith("#"):
        if l.startswith("#CHROM"):
            fileOutput.write("##INFO=<ID=EXON_gene,Number=.,Type=String,Description=\"Gene name\"\n")
            fileOutput.write("##INFO=<ID=EXON_type,Number=.,Type=String,Description=\"Gene type\"\n")
            fileOutput.write("##INFO=<ID=EXON_ID,Number=.,Type=String,Description=\"Exon ID\"\n")
        fileOutput.write(l + "\n")
        continue
    linesplit  = l.split("\t")
    chro = l.split("\t")[0]
    position = int(l.split("\t")[1])
    #print(chro, position)
    interval_start  = position - 100
    interval_stop = position + 100
    search = ( chro + ":" + str(interval_start) + "-" + str(interval_stop))
    #print("tabix /proj/nobackup/sens2017106/wharf/kbilgrav/kbilgrav-sens2017106/ENCODE/hg37_exons_fix.bed.gz " + search + " " + ">" + " " + filename)
    os.system("tabix " + sys.argv[2] + " " + search + " " + ">" + " " + filename) #change to sysargv
    
    gene_tag=";EXON_gene="
    type_tag = ";EXON_type="
    id_tag = ";EXON_ID="
    exon_id = []
    genes = []
    genetype = []
    for ex in open(filename):
        ex = ex.strip("\n")
        exname = (ex.split("\t"))
        exon_id.append(exname[-1])
        genetype.append(exname[-2])
        genes.append(exname[-3])

    if not len(exon_id) ==0:        
        gene_tag+= ",".join(genes)
        type_tag+= ",".join(genetype)
        id_tag+=",".join(exon_id)

        linesplit[7]+= gene_tag + type_tag + id_tag
    fileOutput.write("\t".join(linesplit) + "\n")


fileOutput.close()
os.system('rm ' + filename)