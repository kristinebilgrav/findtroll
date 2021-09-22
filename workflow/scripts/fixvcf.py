import sys
#removes calls with random, HLA or decoy 
deletelist= ['random', 'HLA', 'decoy']
file= open(sys.argv[2], 'w')

for line in open(sys.argv[1]):
	save = True

	if line.startswith('##'):
		id = line.split('ID=')[-1].split(',')[0].split('_')
		hlahash = line.split('ID=')[-1].split(',')[0].split('-')
		for d in deletelist:
			if d in id:
				save = False

		for de in deletelist:
			if de in hlahash:
				save = False

	name = line.split('\t')[0].split('_')
	hla =line.split('\t')[0].split('-')

	for i in name:
		if i in deletelist:
			save = False

	for i in deletelist:
		if i in hla:
			save = False

	for dl in deletelist:
		if dl in line:
			save = False

	if save == True:
		file.write(line)



