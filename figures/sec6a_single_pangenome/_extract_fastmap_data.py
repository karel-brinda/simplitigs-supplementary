#! /usr/bin/env python3

import argparse
import collections
import os
import re
import sys

re_k = re.compile(r'kmers\.(\d+)\.fa')
re_m = re.compile(r'ngono\.([a-z]+)\d*\.fna')
re_time_loading = re.compile(r'fastmap index loading: Real time: ([0-9.]+)')
re_time_matching = re.compile(r'fastmap matching: Real time: ([0-9.]+)')
re_mem_osx = re.compile(r'([0-9]+)\s+maximum resident set size')


def process_file(fn):
    with open(fn) as f:
        p = "".join(f)

    m = re_m.search(p)
    try:
        method = m.group(1)
    except AttributeError:
        method = "NA"

    m = re_k.search(p)
    try:
        k = m.group(1)
    except AttributeError:
        k = "NA"

    m = re_time_loading.search(p)
    try:
        time_loading = m.group(1)
    except AttributeError:
        time_loading = "NA"

    m = re_time_matching.search(p)
    try:
        time_matching = m.group(1)
    except AttributeError:
        time_matching = "NA"

    m = re_mem_osx.search(p)
    try:
        mem_b = m.group(1)
        mem_gb = float(mem_b) / 10**9
    except AttributeError:
        mem_gb = "NA"
    print(method, k, time_loading, time_matching, mem_gb, sep="\t")


def main():
    parser = argparse.ArgumentParser(description="")

    parser.add_argument(
        'file',
        metavar='time.log',
        nargs="+",
        help='',
    )

    args = parser.parse_args()

    print("method", "k", "loading", "matching", "mem", sep="\t")
    for fn in args.file:
        process_file(fn)


if __name__ == "__main__":
    main()
