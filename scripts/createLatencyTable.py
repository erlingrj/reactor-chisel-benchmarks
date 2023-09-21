#!/bin/python3

import os
import sys
from pathlib import Path

def extract_results_from_file(file_path):
    with open(file_path, 'r') as f:
        for line in f:
            return int(line.split("=")[1].strip())
    return None

def create_latex_table(data, output_file="results.tex"):
    table = "% This file is auto-generated \n"
    table += "\\begin{table}[ht]\n\\centering\n"
    table += "\\begin{tabular}{lcc}\n"
    table += " \\toprule \n"
    table += "Test & Latency (clock cycles)\\\\ \n"
    table += "\\midrule \n"
    for test, result in data.items():
        table += f"{test} & {result} \\\\\n"
    table += "\\bottomrule \\\n"
    table += "\\end{tabular} \n"
    table += "\\caption{Reaction invokation latency for programs using the Chisel-target.} \n"
    table += "\\label{tab:latency}"
    table += "\\end{table} \n"
    return table

def main(directory):
    results = {}

    for file_name in os.listdir(directory):
        if file_name.endswith(".txt"):
            path = os.path.join(directory, file_name)
            result = extract_results_from_file(path)
            if result != None:
                test_name = os.path.splitext(file_name)[0]  # Remove .txt extension to get the test name
                results[f"{test_name}.lf"] = result

    table = create_latex_table(results)
    with open(os.path.join(directory, "latency_table.tex"), "w") as f:
        f.write(table)
    with open(os.path.join(directory, "../../../tables/latency_table.tex"), "w") as f:
        f.write(table)


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python script_name.py <directory_path>")
        sys.exit(1)
    main(sys.argv[1])
