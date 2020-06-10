#! /usr/bin/env python3

import argparse
import collections
import os
import re
import sys

header_printed = False

re_exp = re.compile("([0-9a-zA-Z]+)\.([0-9]{0,1})(pa|bc)([0-9]{1,2})\.txt")


def process_fn(fn):
    exp = os.path.basename(fn)
    #sp,_,method = exp.partition(".")
    m = re_exp.match(exp)
    sp, t, m, k = m.groups()

    if t == "":
        t = 1

    return {"species": sp, "threads": t, "method": m, "k": k}


def parse_benchmark(fn):
    try:
        d = process_fn(fn)
    except AttributeError:
        print(f"Cannot parse {fn}", file=sys.stderr)
        raise

    with open(fn) as fo:
        line1, line2 = fo

    parts = line2.strip().split("\t")

    cputime = parts[0]
    mem = parts[2]

    global header_printed
    if not header_printed:
        print("species", "method", "k", "threads", "cputime", "mem", sep="\t")
        header_printed = True

    print(d["species"],
          d["method"],
          d["k"],
          d["threads"],
          cputime,
          mem,
          sep="\t")


def main():
    parser = argparse.ArgumentParser(description="")

    parser.add_argument(
        'txt',
        metavar='str',
        nargs="+",
        help='',
    )

    args = parser.parse_args()

    for fn in args.txt:
        parse_benchmark(fn)


if __name__ == "__main__":
    main()
