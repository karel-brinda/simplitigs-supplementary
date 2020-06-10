#! /usr/bin/env python3

import argparse
import collections
import os
import re
import sys

re_abnormal = re.compile(r'.*abnormally.*')
re_time_loading = re.compile(r'fastmap index loading: Real time: ([0-9.]+)')
re_time_matching = re.compile(r'fastmap matching: Real time: ([0-9.]+)')
re_mem_linux = re.compile(r' ([0-9]+)maxresident\)k')
re_mem_linux2 = re.compile(r'Maximum resident set size \(kbytes\):\s+([0-9]+)')
re_mem_osx = re.compile(r'([0-9]+)\s+maximum resident set size')


def process_file(fn):
    with open(fn) as f:
        s = "".join(f)

    m = re_abnormal.search(s)

    if m:
        time_loading="NA"
        time_matching="NA"
        mem_gb="NA"
        print(0, os.path.basename(fn), time_loading, time_matching, mem_gb, sep="\t")
    else:
        parts=s.split("read 0 ALT contigs")
        del parts[0]
        for i, p in enumerate(parts, 1):
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

            m = re_mem_linux.search(p)
            try:
                mem_kb = m.group(1)
                mem_gb = float(mem_kb) / 10**6
            except AttributeError:
                mem_gb = "NA"

            if mem_gb=="NA":
                m = re_mem_linux2.search(p)
                try:
                    mem_kb = m.group(1)
                    mem_gb = float(mem_kb) / 10**6
                except AttributeError:
                    mem_gb = "NA"

            if mem_gb=="NA":
                m = re_mem_osx.search(p)
                try:
                    mem_b = m.group(1)
                    mem_gb = float(mem_b) / 10**9
                except AttributeError:
                    mem_gb = "NA"
            print(i, os.path.basename(fn), time_loading, time_matching, mem_gb, sep="\t")


def main():
    parser = argparse.ArgumentParser(description="")

    parser.add_argument(
        'file',
        metavar='time.log',
        nargs="+",
        help='',
    )

    args = parser.parse_args()

    print("iter", "file", "loading", "matching", "mem", sep="\t")
    for fn in args.file:
        process_file(fn)


if __name__ == "__main__":
    main()
