import sys

file= open(snakemake.output[0], 'w')
deletelist= ['random', 'HLA', 'decoy', 'chrUn', 'alt']

FLs = {}
for line in open(snakemake.input[0]):
        if line.startswith('#'):
                save = True
                for d in deletelist:
                                if d in line:
                                        save = False
                if save == True:
                        file.write(line)

        if 'INS:ME' in line:
                origin= line.split(';set=')[-1].split(';')[0].split('-')
                #if len(origin) > 1:

                        #file.write(line)

                file.write(line)
