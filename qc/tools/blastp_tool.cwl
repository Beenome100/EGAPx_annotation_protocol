cwlVersion: v1.2
class: CommandLineTool

baseCommand: blastp

requirements:
    -   class: InitialWorkDirRequirement
        listing:
            -   entry: $(inputs.blast_database)       
                entryname: dmel_blastdb                        

inputs:         
    species_name:
        type: string
        
    in_protein_sequences:
        type: File
        inputBinding:
            position: 1
            prefix: -query
    
    blast_database:
        type: Directory
            
    threads:
        type: int
        inputBinding:
            position: 6
            prefix: -num_threads
         
arguments:
    -   prefix: -db
        position: 2
        valueFrom: dmel_blastdb/Dmel_refseq_release6
        
    -   prefix: -out
        position: 3
        valueFrom: $(inputs.species_name)_on_Dmel_blastp
    
    -   prefix: -outfmt
        position: 4
        valueFrom: "6"
    
    -   prefix: -num_alignments
        position: 5
        valueFrom: "1"

outputs:
    out_blastp_results: 
        type: File
        outputBinding:
            glob: $(inputs.species_name)_on_Dmel_blastp