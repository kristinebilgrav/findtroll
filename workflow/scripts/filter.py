import sys

file= open(sys.argv[2], 'w')
deletelist= ['random', 'HLA', 'decoy', 'chrUn', 'alt']

FLs = {}
for line in open(sys.argv[1]):
        if line.startswith('#'):
                save = True
                for d in deletelist:
                                if d in line:
                                        save = False
                if save == True:
                        file.write(line)

        if 'INS:ME' in line:
                origin= line.split(';set=')[-1].split(';')[0].split('-')
                if len(origin) > 1:

                        file.write(line)
