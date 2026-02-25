cwlVersion: v1.2
class: CommandLineTool

baseCommand: agat_sp_extract_sequences.pl

inputs:
    in_reduced_gff:
        type: File
        inputBinding:
            position: 1
            prefix: --gff
    
    in_genome:
        type: File
        inputBinding:
            position: 2
            prefix: --fasta

arguments:
    -   prefix: --output
        position: 3
        valueFrom: $(inputs.in_reduced_gff.basename)_proteins.fasta

    -   prefix: --type
        position: 4
        valueFrom: cds
    
    -   --protein

    -   --clean_final_stop

outputs:
    out_protein_sequences: 
        type: File
        outputBinding:
            glob: $(inputs.in_reduced_gff.basename)_proteins.fasta