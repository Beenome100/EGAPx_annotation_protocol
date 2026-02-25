cwlVersion: v1.2
class: CommandLineTool

baseCommand: count_pident.py

inputs:
    in_blastp_results:
        type: File
        inputBinding:
            position: 1
            prefix: -i
    
    species_name:
        type: string
        inputBinding:
            position: 2
            prefix: -s

outputs:
    out_pident_files:
        type:
            type: array 
            items: File
        outputBinding:
            glob: "*_pident_counts*"