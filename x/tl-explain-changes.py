#!/usr/bin/env python3

"""
Explains each of the rejected changes.
"""

import json

def loadstate():
    with open("WORK.wrk", "r") as filep:
        return json.load(filep)


def main():
    newstate = []
    state = loadstate()
    index = 0
    for entry in state:
        if entry["__status__"] != "rejected":
            newstate.append(entry)
            continue
        if len(entry['added']) < 1 or len(entry['removed']) < 1:
            continue
        index += 1
        print("")
        print(f"I would revert {entry['added'][0]} back to {entry['removed'][0]} because")
        print(f"{entry['__comment__'].lower()}.")
        print("")
        if False:
            print("Here are some stats:")
            print("")
            print(f"{json.dumps(entry['__statistics__'])}")
            print("")
        print("")
        print("")


if __name__ == "__main__":
    main()
