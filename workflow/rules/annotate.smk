#rule to annotate with vep using custom features.

rule vep:
        input:
                "results/{sample}.query.vcf"
        output:
                "results/{sample}.annotated.vcf"
        shell:
                "{config[vep_path]} vep --custom {config[vep_custom]} --cache -i {input} -o {output} --dir {config[vep_basedir]} --offline --vcf --assembly {config[vep_assembly]} --per_gene --format vcf"


