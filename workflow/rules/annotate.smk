#rule to annotate with vep using custom features.

rule vep_L1:
        input:
                "{PWD}results/{sample}_L1_query.vcf"
        output:
                "{PWD}results/{sample}_L1_annotated.vcf"
        shell:
                "{config[vep_path]} vep --custom {config[vep_custom]} --cache -i {input} -o {output} --dir {config[vep_basedir]} --offline --vcf --assembly {config[vep_assembly]} --per_gene --format vcf"

rule vep_ALU:
        input:
                "{PWD}results/{sample}_ALU_query.vcf"
        output:
                "{PWD}results/{sample}_ALU_annotated.vcf"
        shell:
                "{config[vep_path]} vep --custom {config[vep_custom]} --cache -i {input} -o {output} --dir {config[vep_basedir]} --offline --vcf --assembly {config[vep_assembly]} --per_gene --format vcf"

rule vep_HERV:
        input:
                "{PWD}results/{sample}_HERV_query.vcf"
        output:
                "{PWD}results/{sample}_HERV_annotated.vcf"
        shell:
                "{config[vep_path]} vep --custom {config[vep_custom]} --cache -i {input} -o {output} --dir {config[vep_basedir]} --offline --vcf --assembly {config[vep_assembly]} --per_gene --format vcf"

rule vep_SVA:
        input:
                "{PWD}results/{sample}_SVA_query.vcf"
        output:
                "{PWD}results/{sample}_SVA_annotated.vcf"
        shell:
                "{config[vep_path]} vep --custom {config[vep_custom]} --cache -i {input} -o {output} --dir {config[vep_basedir]} --offline --vcf --assembly {config[vep_assembly]} --per_gene --format vcf"


