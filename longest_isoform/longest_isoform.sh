#!/bin/bash

SPECIES=
GFF=
# Use complete.genome.fna from EGAPx output folder
GENOME=
CONFIG_FILE=agat_config.yaml

### GFF filtering
agat_sp_keep_longest_isoform.pl --gff "$GFF" --output "${SPECIES}_longest_isoform.gff" --config "$CONFIG_FILE"
agat_sp_filter_feature_by_attribute_value.pl --gff "${SPECIES}_longest_isoform.gff" --type gene --attribute gene_biotype --value protein_coding --test ! --output "${SPECIES}_longest_isoform_protein_coding.gff" --config "$CONFIG_FILE"
agat_sp_filter_feature_by_attribute_value.pl --gff "${SPECIES}_longest_isoform_protein_coding.gff" --type pseudogene --attribute pseudo --value true --output "${SPECIES}_longest_isoform_protein_coding_no_pseudo.gff" --config "$CONFIG_FILE"
mv "${SPECIES}_longest_isoform_protein_coding_no_pseudo.gff" "${SPECIES}_longest_isoform_protein_coding.gff"
### Extract sequences
agat_sp_extract_sequences.pl --gff "${SPECIES}_longest_isoform_protein_coding.gff" -f "$GENOME" -t cds -p --clean_final_stop --output "${SPECIES}_longest_isoform_protein_coding.faa" --config "$CONFIG_FILE"
rm *_report.txt
rm *_discarded.gff
rm *.index
### Converts sequences from interleaved to single-line
fasta_formatter -w 0 -i "${SPECIES}_longest_isoform_protein_coding.faa" -o "${SPECIES}_longest_isoform_protein_coding_1line.faa"
mv "${SPECIES}_longest_isoform_protein_coding_1line.faa" "${SPECIES}_longest_isoform_protein_coding.faa"
### Removes ">rna-" from the start of each header and strips any information after the gene name. The result is ">Gene_name-isoform_number (assuming NCBI input format)"
sed 's/^>rna-/>/' "${SPECIES}_longest_isoform_protein_coding.faa" > protein_clean1.faa
sed '/^>/ s/ .*//' protein_clean1.faa > "${SPECIES}_longest_isoform_protein_coding.faa"
rm protein_clean1.faa

chmod 440 "$SPECIES"*

