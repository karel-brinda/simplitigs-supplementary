#! /usr/bin/env python3

import argparse
import collections
import os
import re
import sys

header_printed = False

re_hostname = re.compile("Hostname:\t(.*)")
re_cputime = re.compile("system ([0-9:.]+)elapsed ")
re_mem = re.compile("avgdata ([0-9]+)maxresident\)k")

re_exp = re.compile("([0-9a-zA-Z]+)\.([0-9]{0,1})(pa|bc)([0-9]{1,2})\.log")


def process_fn(fn):
    exp = os.path.basename(fn)
    #sp,_,method = exp.partition(".")
    m = re_exp.match(exp)
    sp, t, m, k = m.groups()

    if t == "":
        t = 1

    return {"species": sp, "threads": t, "method": m, "k": k}


def process_content(s):
    m = re_hostname.search(s)
    if m:
        hostname = m.group(1)
    else:
        hostname = "NA"
    #print(hostname)

    m = re_cputime.search(s)
    if m:
        cputime_str = m.group(1)
        if cputime_str.count(":") != 2:
            if cputime_str[1] == ":":
                cputime_str = f"0{cputime_str}"
            cputime_str = f"0:{cputime_str}"
        h_, m_, s_ = cputime_str.split(":")
        cputime = float(s_) + 60 * int(m_) + 3600 * int(h_)
    else:
        cputime = "NA"
    #print(cputime)

    m = re_mem.search(s)
    if m:
        mem = m.group(1)
    else:
        mem = "NA"
    #print(mem)

    return {"hostname": hostname, "cputime": cputime, "mem": mem}


def parse_log(fn):
    try:
        d = process_fn(fn)
    except AttributeError:
        print(f"Cannot parse {fn}", file=sys.stderr)
        raise

    with open(fn) as fo:
        s = "".join(fo)

    try:
        dd = process_content(s)
    except AttributeError:
        print(f"Cannot parse the content of {fn}", file=sys.stderr)
        return

    global header_printed
    if not header_printed:
        print("species",
              "method",
              "k",
              "threads",
              "hostname",
              "cputime",
              "mem",
              sep="\t")
        header_printed = True

    print(d["species"],
          d["method"],
          d["k"],
          d["threads"],
          dd["hostname"],
          dd["cputime"],
          dd["mem"],
          sep="\t")


def main():
    parser = argparse.ArgumentParser(description="")

    parser.add_argument(
        'log',
        metavar='str',
        nargs="+",
        help='',
    )

    args = parser.parse_args()

    for fn in args.log:
        parse_log(fn)


if __name__ == "__main__":
    main()
