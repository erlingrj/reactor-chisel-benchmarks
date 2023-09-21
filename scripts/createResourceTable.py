#!/usr/bin/python3

import os
import sys
import re

def read_results(directory, selected_tests):
    """Reads the results from the files in the given directory for selected tests."""
    results = {}

    for filename in os.listdir(directory):
        filepath = os.path.join(directory, filename)
        if os.path.isfile(filepath):
            with open(filepath, 'r') as f:
                for line in f:
                    parts = line.strip().split('=')
                    if len(parts) == 2:
                        test_name, result = parts
                        if test_name in selected_tests:
                            if test_name == "Delay":
                                delay = float(result)
                                result = f"{1000/((2 - delay)):.2f}"
                                test_name = "FMAX"
                            if test_name not in results:
                                results[test_name] = {}
                            results[test_name][filename] = result

    return results

def gen_test_name(name):
    if name == "LUT":
        return "LUTs"
    elif name == "FF":
        return "Flip flops"
    elif name == "FMAX":
        return "Fmax (MHz)"

def gen_bench_name(name):
    return name.replace(".txt", "")

def testname_sort_key(filename):
     # Split the name and the extension
    name, ext = filename.rsplit('.', 1)
    
    # Extract any numeric value from the name
    match = re.search(r'(\d+)', name)
    if match:
        # Return the name without the numeric part and the numeric value as an integer.
        # This way, 'test10' and 'test2' will be sorted as ('test', 10) and ('test', 2) respectively.
        return (name[:match.start()], int(match.group(1)))
    else:
        # If no numeric part is present, just return the name with a high priority for sorting
        return (name, 0)



def generate_latex_table(results):
    """Generates a LaTeX table from the results."""
    headers = [""] + [gen_test_name(x) for x in results.keys()]
    table = "% This file is auto-generated \n"
    table += "\\begin{table}[ht]\n\\centering\n"
    table += "\\begin{tabular}{l" + "c" * len(headers) + "}\n"
    table += " \\toprule \n"
    table += "Test " + "& ".join(headers) + " \\\\ \n"
    table += "\\midrule \n"
    
    for benchmark in sorted(list(results.values())[0], key=testname_sort_key):
        row = gen_bench_name(benchmark)
        for test in results.items():
            row += f" & {test[1][benchmark]}"
        row +=" \\\\ \n"
        table += row

    table += "\\bottomrule \\\\\n"
    table += "\\end{tabular} \n"
    table += "\\caption{Resource utilization for standalone circuits using the Chisel-target} \n"
    table += "\\label{tab:res_util}"
    table += "\\end{table} \n"


    return table

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python script_name.py <results director>")
        sys.exit(1)
    
    directory = sys.argv[1]

    if not os.path.exists(directory):
        print(f"Directory '{directory}' does not exist!")
        sys.exit(1)

    selected_tests = ("LUT", "FF", "Delay")

    results = read_results(directory, selected_tests)
    latex_table = generate_latex_table(results)

    print(latex_table)
    with open(os.path.join(directory, "resource_table.tex"), 'w') as file:
        file.write(latex_table)
    with open(os.path.join(directory, "../../../tables/resource_table.tex"), "w") as file:
        file.write(latex_table)
