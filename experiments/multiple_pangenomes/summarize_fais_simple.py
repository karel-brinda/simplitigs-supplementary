#! /usr/bin/env python3

import argparse
import collections
import os
import re
import sys

header = False


def process_fai(fn, k):
    name = os.path.basename(fn).replace(".fai", "")
    with open(fn) as f:
        cum = 0
        for simplitigs, x in enumerate(f, 1):
            p = x.split()
            try:
                cum += int(p[1])
            except IndexError:
                print(f"Error: the line '{x}' (#{simplitigs}) of file '{fn}' could not be parsed", file=sys.stderr)
    kmers = cum - (k - 1) * simplitigs
    global header
    if not header:
        print(
            "name",
            "simplitigs",
            "cum len",
            "kmers",
            sep="\t")
        header = True
    print(name, simplitigs, cum, kmers, sep="\t")


def main():
    parser = argparse.ArgumentParser(description="")

    parser.add_argument(
        'file',
        metavar='str',
        nargs="+",
        help='FAI file',
    )

    parser.add_argument(
        '-k',
        type=int,
        metavar='int',
        required=True,
        dest='k',
        help='k-mer size',
    )

    args = parser.parse_args()

    for x in args.file:
        process_fai(x, k=args.k)


if __name__ == "__main__":
    main()
