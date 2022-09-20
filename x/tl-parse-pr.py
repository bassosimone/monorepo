#!/usr/bin/env python3

"""
This script parses the commits inside a test lists PR.

To checkout the PR, run:

    cd ./repo/test-lists/
	gh pr checkout 0000

where `0000` is the PR number.

Then, figure out the base commit `abcdef` by looking at the history.

Then, obtain the list of patches using:

    git format-patch abcdef

You will now have a file for each patch in the test-lists dir.

You should run this script passing it `*.patch` as input.
"""

import collections
import json
import sys
from typing import Any, List


def gather_hunks(filenames: List[str]) -> List[Any]:
    hunks = []
    for filename in filenames:
        with open(filename, "r") as filep:
            cur_hunk = {
                "__status__": "new",
                "__file__": filename,
                "__subject__": None,
                "added": [],
                "removed": [],
            }
            lines = collections.deque([line.rstrip() for line in filep])
            # find the beginning of the patch
            while lines:
                line = lines[0]
                if line.startswith("Subject: "):
                    cur_hunk["__subject__"] = line.strip()[9:]
                if line.startswith("@@ "):
                    break
                lines.popleft()
            # extract the changes
            while lines:
                line = lines[0]
                if line == "--":  # end of patch signature
                    break
                if line.startswith("-"):
                    cur_hunk["removed"].append(line[1:].split(",")[0])
                elif line.startswith("+"):
                    cur_hunk["added"].append(line[1:].split(",")[0])
                else:
                    pass  # nothing
                lines.popleft()
            hunks.append(cur_hunk)
    return hunks


def main():
    hunks = gather_hunks(sys.argv[1:])
    json.dump(hunks, sys.stdout)
    sys.stdout.write("\n")


if __name__ == "__main__":
    main()
