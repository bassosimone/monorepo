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
    for entry in state:
        if entry["__status__"] != "rejected":
            newstate.append(entry)
            continue
        if len(entry['added']) >= 1 and len(entry['removed']) >= 1:
            print("")
            print(f"I would revert {entry['added'][0]} back to {entry['removed'][0]} because")
            print(f"{entry['__comment__'].lower()}.")
            print("")
        elif len(entry['removed']) >= 1:
            print("")
            print(f"I would reinstate {entry['removed'][0]} because")
            print(f"{entry['__comment__'].lower()}.")
            print("")
        if False:
            continue
            print("Here are some stats:")
            print("")
            print(f"{json.dumps(entry['__statistics__'])}")
            print("")
        print("")
        print("")


if __name__ == "__main__":
    main()
