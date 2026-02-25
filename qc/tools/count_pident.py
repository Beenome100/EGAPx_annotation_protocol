#!/usr/bin/env python3

import sys
import argparse
import os
import matplotlib.pyplot as plt

# Store reference datasets in the code
REFERENCE_COUNTS = {
    "Apis mellifera": {"0-49": 9199, "50-59": 1951, "60-69": 1354, "70-79": 786, "80-89": 382, "90-99": 155, "100": 14},
    "Bombus terrestris": {"0-49": 9537, "50-59": 1977, "60-69": 1397, "70-79": 815, "80-89": 394, "90-99": 149, "100": 13},
    "Dufourea novaeangliae": {"0-49": 8819, "50-59": 1918, "60-69": 1382, "70-79": 824, "80-89": 361, "90-99": 156, "100": 18},
    "Hylaeus volcanicus": {"0-49": 10914, "50-59": 2028, "60-69": 1403, "70-79": 815, "80-89": 405, "90-99": 146, "100": 15},
    "Osmia bicornus bicornus": {"0-49": 10525, "50-59": 2022, "60-69": 1321, "70-79": 818, "80-89": 388, "90-99": 179, "100": 21},
}

def count_pident_ranges(blastp_file):
    bins = {
        "0-49": 0,
        "50-59": 0,
        "60-69": 0,
        "70-79": 0,
        "80-89": 0,
        "90-99": 0,
        "100": 0
    }
    
    with open(blastp_file, 'r') as f:
        for line in f:
            columns = line.strip().split('\t')
            if len(columns) < 3:
                continue
            
            try:
                pident = float(columns[2])
            except ValueError:
                continue
            
            if 0 <= pident < 50:
                bins["0-49"] += 1
            elif 50 <= pident < 60:
                bins["50-59"] += 1
            elif 60 <= pident < 70:
                bins["60-69"] += 1
            elif 70 <= pident < 80:
                bins["70-79"] += 1
            elif 80 <= pident < 90:
                bins["80-89"] += 1
            elif 90 <= pident < 100:
                bins["90-99"] += 1
            elif pident == 100:
                bins["100"] += 1
    
    return bins

def print_cumulative_counts(counts, species_name):
    print(f"Cumulative counts for {species_name}:")
    running_total = 0
    cumulative_counts = {}
    for key in reversed(counts.keys()):
        running_total += counts[key]
        cumulative_counts[key] = running_total
        print(f"{key}: {running_total}")
    return cumulative_counts

def plot_pident_counts(counts, species_name, output_file):
    categories = list(counts.keys())[::-1]  # Reverse order to match increasing threshold on x-axis
    
    # Compute cumulative counts (corrected accumulation)
    cumulative_values = print_cumulative_counts(counts, species_name)
    plotted_values = [cumulative_values[key] for key in categories]
    
    plt.figure(figsize=(8, 6))
    plt.plot(categories, plotted_values, marker='o', linestyle='--', color='black', linewidth=2, label=species_name)
    plt.xticks(categories, labels=["100", "≥90", "≥80", "≥70", "≥60", "≥50", "≥0"])
    
    # Plot reference datasets with cumulative counts
    for ref_name, ref_counts in REFERENCE_COUNTS.items():
        ref_cumulative_values = {}
        running_total = 0
        for key in reversed(ref_counts.keys()):
            running_total += ref_counts[key]
            ref_cumulative_values[key] = running_total
        ref_plotted_values = [ref_cumulative_values[key] for key in categories]
        plt.plot(categories, ref_plotted_values, marker='x', linestyle='-', label=f'{ref_name}')
    
    plt.yscale("log")  # Log scale for better visualization of small values
    plt.xlabel("Target percent coverage")
    
    plt.title("Cumulative number of genes with an alignment to Drosophila melanogaster RefSeq proteins")
    plt.legend()
    plt.grid(True, which="both", linestyle="--", linewidth=0.5)
    
    plt.savefig(f"{output_file}.png")
    print(f"Plot saved as {output_file}.png")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Analyze BLAST percent identity distributions and plot results.")
    parser.add_argument("-i", "--input", required=True, help="Path to the input BLAST output file (outfmt 6).")
    parser.add_argument("-s", "--species", required=True, help="Name of the species.")
    args = parser.parse_args()
    
    blastp_file = args.input
    species_name = args.species
    
    result = count_pident_ranges(blastp_file)
    
    basename = os.path.basename(blastp_file)
    nameroot = os.path.splitext(basename)[0]
    output_file = f"{nameroot}_pident_counts"
    output_file_counts = f"{output_file}.txt"
    
    with open(output_file_counts, 'w') as out:
        for key, value in result.items():
            out.write(f"{key}: {value}\n")
    
    print(f"Pident counts written to {output_file_counts}")
    
    plot_pident_counts(result, species_name, output_file)
