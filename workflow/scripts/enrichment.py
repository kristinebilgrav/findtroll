import os
import sys
import yaml
#counts instance of a fewature in TE affecting protein coding pos in ONE individual

features = ['EXON_gene=','TFs=', 'SegDup=', 'DNase=']
featurecount = {'EXON_gene=':{},'TFs=':{}, 'SegDup=':{}, 'DNase=':{}}

totalTEs= 0
for line in open(sys.argv[1]):
    if line.startswith('#'):
        continue
    totalTEs += 1
    MEtype=line.strip("\n").split('MEINFO=')[-1].split(',')[0]
    for f in features:
        if f in line and 'protein_coding' in line:
            item = set(line.split(f)[-1].split(';')[0].split('\t')[0].split(','))
            #print(item)
            for g in item:
                if g not in featurecount[f]:
                    featurecount[f][g] = {}
                if MEtype not in featurecount[f][g]:
                    featurecount[f][g][MEtype] = 0
                featurecount[f][g][MEtype] += 1

total_exons = 0
for k in featurecount[EXON_gene][ALU]:
    total_exons += int(k)

#repeat for all TEs

name = sys.argv[1].split('.')[0].split('_')[0]
with open(name + 'stats.yaml', 'w') as file:
    yaml.dump(featurecount, file, default_flow_style=False)
