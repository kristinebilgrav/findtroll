#rules to prep and query sample against common variants in db


#filter for only ME insertions:
rule filter:
	input:
		'results/{sample}.merged.vcf'
	output:
		'results/{sample}.filtered.vcf'
	script:
		'scripts/filter.py {input} {output}'

#sort with bcftools
rule sort:
	input:
		'results/{sample}.filtered.vcf'
	output:
		'results/{sample}.sorted.filtered.vcf'
	container:
		"docker://kristinebilgrav/findtroll:latest"
	shell:
		'bcftools sort {input} {output}'

rule svdb_query:
    input:
        'results/{sample}.sorted.filtered.vcf'
    output:
        'results/{sample}.query.vcf'
    shell:
        'svdb --query --query_vcf {input} --db {config[ME_db]} --overlap -1 --bnd_distance 150 > {output}'