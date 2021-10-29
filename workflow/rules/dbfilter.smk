#rules to prep and query sample against common variants in db


#filter for only ME insertions:
rule filter:
	input:
		'{PWD}results/{sample}_merged.vcf'
	output:
		'{PWD}results/{sample}_filtered.vcf'
	script:
		'scripts/filter.py {input} {output}'

#sort with bcftools
rule sort:
	input:
		'{PWD}results/{sample}_filtered.vcf'
	output:
		'{PWD}results/{sample}_sorted_filtered.vcf'
	container:
		"findtroll.sif"
	shell:
		'bcftools sort {input} {output}'


rule split:
    input:
        '{PWD}results/{sample}_sorted_filtered.vcf'
    output:
        ALU='{PWD}results/{sample}_ALU.vcf',
        L1='{PWD}results/{sample}_L1.vcf',
        SVA='{PWD}results/{sample}_SVA.vcf',
        HERV='{PWD}results/{sample}_HERV.vcf'
    script:
        'scripts/splitonME.py {input}'


rule svdb_query_L1:
    input:
        '{PWD}results/{sample}_L1.vcf'
    output:
        '{PWD}results/{sample}_L1_query.vcf'
    shell:
        'svdb --query --query_vcf {input} --db {config[L1_db]} --overlap -1 --bnd_distance 150 > {output}'


rule svdb_query_SVA:
    input:
        '{PWD}results/{sample}_SVA.vcf'
    output:
        '{PWD}results/{sample}_SVA_query.vcf'
    shell:
        'svdb --query --query_vcf {input} --db {config[SVA_db]} --overlap -1 --bnd_distance 150 > {output}'


rule svdb_query_HERV:
    input:
        '{PWD}results/{sample}_HERV.vcf'
    output:
        '{PWD}results/{sample}_HERV_query.vcf'
    shell:
        'svdb --query --query_vcf {input} --db {config[HERV_db]} --overlap -1 --bnd_distance 150 > {output}'


rule svdb_query_ALU:
    input:
        '{PWD}results/{sample}_ALU.vcf'
    output:
        '{PWD}results/{sample}_ALU_query.vcf'
    shell:
        'svdb --query --query_vcf {input} --db {config[ALU_db]} --overlap -1 --bnd_distance 150 > {output}'
