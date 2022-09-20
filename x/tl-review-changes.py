#!/usr/bin/env python3

"""
Walk through a list of changes and review them.

Expected file named WORK.wrk to contain changes produced by tl-parse-pr.
"""


import json
import urllib.parse
import urllib.request


def loadstate():
    with open("WORK.wrk", "r") as filep:
        return json.load(filep)


def writeback(state):
    with open("WORK.wrk", "w") as filep:
        json.dump(state, filep)


def summarize(final_url, data):
    anomaly = 0
    confirmed = 0
    numdays = 0
    ok = 0
    failure = 0
    total = 0
    for entry in data["result"]:
        anomaly += entry["anomaly_count"]
        confirmed += entry["confirmed_count"]
        numdays += 1
        ok += entry["ok_count"]
        failure += entry["failure_count"]
        total += entry["measurement_count"]

    return {
        "__source__": final_url,
        "anomaly_count": anomaly,
        "confirmed_count": confirmed,
        "numdays": numdays,
        "ok_count": ok,
        "failure_count": failure,
        "total_count": total,
    }


def viewurlstats(target_url):
    initial_url = "https://api.ooni.io/api/v1/aggregation?"
    params = {
        "input": target_url,
        "test_name": "web_connectivity",
        "axis_x": "measurement_start_day",
        "since": "2022-08-20",
        "until": "2022-9-20",
    }
    result = {}
    final_url = initial_url + urllib.parse.urlencode(params)
    with urllib.request.urlopen(final_url) as resp:
        data = json.loads(resp.read())
        stats = summarize(final_url, data)
        result[target_url] = stats
    return result


def viewstats(entry):
    result = {}
    for url in entry["removed"]:
        stats = viewurlstats(url)
        result.update(stats)
    for url in entry["added"]:
        stats = viewurlstats(url)
        result.update(stats)
    return result


def printstats(stats):
    for target_url, value in stats.items():
        anomaly = value["anomaly_count"]
        confirmed = value["confirmed_count"]
        numdays = value["numdays"]
        ok = value["ok_count"]
        failure = value["failure_count"]
        total = value["total_count"]
        print(f"- target_url: {target_url}")
        print(f"  - numdays:    {numdays:-8d}")
        print(f"  - total:      {total:-8d}")
        print(f"  - confirmed:  {confirmed:-8d} | {(100.0 * confirmed)/total:-8.3f}%")
        print(f"  - anomaly:    {anomaly:-8d} | {(100.0 * anomaly)/total:-8.3f}%")
        print(f"  - failure:    {failure:-8d} | {(100.0 * failure)/total:-8.3f}%")
        print(f"  - ok:         {ok:-8d} | {(100.0 * ok)/total:-8.3f}%")
        print("")


def promptloop(entry):
    while True:
        print("")
        print(f'* {entry["__subject__"]}')
        print("")
        print(f'- {entry["removed"]}')
        print(f'+ {entry["added"]}')
        print("")

        if "__statistics__" not in entry:
            stats = viewstats(entry)
            entry["__statistics__"] = stats
        stats = entry["__statistics__"]
        printstats(stats)

        choice = ""
        while True:
            print("")
            choice = input("(A)ccept, (R)reject, or (S)skip? ")
            choice = choice.upper()
            if choice in ("A", "C", "R", "S", "V"):
                break

        if choice == "A":
            comment = input("Explain why you're accepting: ")
            entry["__comment__"] = comment
            entry["__status__"] = "accepted"
            return entry

        if choice == "R":
            comment = input("Explain why you're rejecting: ")
            entry["__comment__"] = comment
            entry["__status__"] = "rejected"
            return entry

        assert choice == "S"
        return entry



def main():
    newstate = []
    state = loadstate()
    prompting = True
    for entry in state:
        if entry["__status__"] != "new":
            newstate.append(entry)
            continue

        if set(entry["added"]) == set(entry["removed"]):
            entry["__status__"] = "accepted"
            newstate.append(entry)
            continue

        if prompting:
            try:
                entry = promptloop(entry)
            except EOFError:
                prompting = False
                print("got EOF, saving remaining entries and exiting")
            except KeyboardInterrupt:
                prompting = False
                print("got ^C, saving remaining entries and exiting")
        newstate.append(entry)

    writeback(state)


if __name__ == "__main__":
    main()
