#!/usr/bin/python3

# splits a pdf into 3 versions based on the information in the
# <pdf-base-name>.pagebounds file

import sys, os
import argparse
from pdftools.pdftools import pdf_copy
from pdftools.parseutil import parentparser

def process_arguments(args):
    parser = argparse.ArgumentParser(
        parents=[parentparser],
        description="Break a tutorial pdf into student, solutions, and ta versions."
    )
    # input
    parser.add_argument('input',
                        type=str,
                        default=None,
                        help='input file containing the source pages')

    return parser.parse_args(args)

def parse_ranges(l):
    ret = {}
    for line in l:
        first, last = line.split('=')
        first = first.strip()
        last = last.strip()
        ret[first] = last
    return ret

if __name__ == "__main__":
    args = process_arguments(sys.argv[1:])
    input_file = args.input
    base, ext = os.path.splitext(input_file)
    page_ranges_file = base + ".pagebounds"

    if not os.path.exists(page_ranges_file):
        print("Error: Missing file '{}'".format(page_ranges_file))
        sys.exit(0)

    with open(page_ranges_file) as f:
        ranges = parse_ranges(f.readlines())

    if "tutorialstart" in ranges:
        outfile = "{}-student{}".format(base, ext)
        print("generating {}".format(outfile))
        pdf_copy(input_file, outfile, ["{}-{}".format(ranges["tutorialstart"], ranges["tutorialend"])], True)
    if "solutionsstart" in ranges:
        outfile = "{}-solutions{}".format(base, ext)
        print("generating {}".format(outfile))
        pdf_copy(input_file, outfile, ["{}-{}".format(ranges["tutorialstart"], ranges["solutionsend"])], True)
    if "instructionsstart" in ranges:
        outfile = "{}-ta{}".format(base, ext)
        print("generating {}".format(outfile))
        pdf_copy(input_file, outfile, ["{}-{}".format(ranges["tutorialstart"], ranges["instructionsend"])], True)
