cwlVersion: v1.2
class: Workflow

inputs:
    threads: int
    species_name: string
    genome_assembly: File
    gff_file: File
    blast_database: Directory
    

outputs:
    pident_files:
        type: 
            type: array
            items: File
        outputSource:
            -   pident/out_pident_files
            
steps:
    reduce_isoforms:
        run:
            tools/agat_sp_keep_longest_isoform_tool.cwl
        in:
            in_gff: gff_file
        out:
            [out_reduced_gff]
    
    get_protein_sequences:
        run:
            tools/agat_sp_extract_sequences_tool.cwl
        in:
            in_reduced_gff: reduce_isoforms/out_reduced_gff
            in_genome: genome_assembly
        out:
            [out_protein_sequences]
    
    blastp:
        run:
            tools/blastp_tool.cwl
        in:
            in_protein_sequences: get_protein_sequences/out_protein_sequences
            blast_database: blast_database
            species_name: species_name
            threads: threads
            
        out:
            [out_blastp_results]       
            
    pident:
        run:
            tools/pident_tool.cwl
        in:
            in_blastp_results: blastp/out_blastp_results
            species_name: species_name
        out:
            [out_pident_files]
            
