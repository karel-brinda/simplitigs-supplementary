#! /usr/bin/env python3

import argparse
import os
import sys

header = False


def process_fai(fn):
    name = os.path.basename(fn).replace(".fai", "")
    with open(fn) as f:
        cum = 0
        for simplitigs, x in enumerate(f, 1):
            p = x.split()
            try:
                cum += int(p[1])
            except IndexError:
                print(f"Error: the line '{x}' (#{simplitigs}) of file '{fn}' could not be parsed", file=sys.stderr)
    global header
    if not header:
        print(
            "fn",
            "ns",
            "cl",
            sep="\t")
        header = True
    print(name, simplitigs, cum, sep="\t")


def main():
    parser = argparse.ArgumentParser(description="")

    parser.add_argument(
        'file',
        metavar='str',
        nargs="+",
        help='FAI file',
    )

    args = parser.parse_args()

    for x in args.file:
        process_fai(x)


if __name__ == "__main__":
    main()
