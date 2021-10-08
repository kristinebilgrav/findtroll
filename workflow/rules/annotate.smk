#rules to annotate with vep and tabix (additional features). 

rule vep:
        input:
                "results/{sample}_merged.vcf"
        output:
                "results/{sample}_merged_vep.vcf"
        shell:
                "{config[vep_path]} vep --cache -i {input} -o {output} --vcf --assembly {config[vep_assembly]} --per_gene"


rule exons:
	input:
		file = 'results/{sample}_merged_vep.vcf',
		exons=expand("{exons}", exons=config["exons"])
	output:
		'results/{sample}_vep_exons.vcf' #wildcards -- script legger til navn - fix
	script:
		"scripts/find_exons.py {input.file} {input.exons} {output}"

rule tfs:
	input:
		file= 'results/{sample}_vep_exons.vcf',
		tfs = expand("{tfs}", tfs=config["tfs"])
	output:
		'results/{sample}_VEP_exons_tfs.vcf'
	script:
		"scripts/find_tfs.py {input.file} {input.tfs} {output}"

rule SegDups:
	input:
		file='results/{sample}_VEP_exons_tfs.vcf',
		segdups = expand("{segdups}", segdups=config["segdups"])
	output:
		'results/{sample}_VEP_exons_tfs_segdup.vcf'
	script:
		"scripts/find_segdups.py {input.file} {input.tfs} {output}"

rule DNase:
	input:
		file ='results/{sample}_VEP_exons_tfs_segdup.vcf',
		dnase= expand("{dnase}", dnase=config["dnase"])
	output:
		'results/{sample}_VEP_exons_tfs_segdup_dnase.vcf'
	script:
		"scripts/find_dnase.py {input.file} {input.dnase} {output}"


