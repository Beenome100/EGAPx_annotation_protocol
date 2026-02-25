cwlVersion: v1.2
class: CommandLineTool

baseCommand: agat_sp_keep_longest_isoform.pl
                
inputs:
    in_gff:
        type: File
        inputBinding:
            position: 1
            prefix: --gff           
            
arguments:
    -   prefix: --output
        valueFrom: $(inputs.in_gff.basename)_reduced.gff
        position: 2

outputs:
    out_reduced_gff: 
        type: File
        outputBinding:
            glob: $(inputs.in_gff.basename)_reduced.gff
