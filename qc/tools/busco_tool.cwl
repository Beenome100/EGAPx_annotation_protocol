cwlVersion: v1.2
class: CommandLineTool

baseCommand: busco

inputs:
    in_protein_sequences:
        type: File
        inputBinding:
            position: 1
            prefix: --in
    
    in_busco_database:
        type: Directory
        inputBinding:
            position: 2
            prefix: --lineage_dataset
    
    threads:
        type: int
        inputBinding:
            position: 3
            prefix: --cpu

arguments:
    -   prefix: --out
        position: 4
        valueFrom: busco

    -   prefix: --mode
        position: 5
        valueFrom: protein
    
    -   --offline

outputs:
    out_busco: 
        type: Directory
        outputBinding:
            glob: busco