// Command filternet executes a command inside a network namespace
// applying optional netem constraints and iptables rules.
//
// Filternet will create a network namespace. You can configure
// the namespace name using the --namespace-name flag. Otherwise,
// we'll use the default name: "jafar".
//
// Then, filternet will create two network interfaces named
// `<namespace-name>-0` and `<namespace-name>-1`. Thus, by default
// those interface will be named "jafar0" and "jafar1".
//
// The first interface will live in the current namespace while the
// second one will live in the new namespace.
//
// Filternet will apply netem policies to outgoing and incoming
// traffic. By default there are no policies, but you can specify
// them using the `--download` and `--upload` flags.
//
// You can also apply optional blocking policies using the
// `--firewall-rule` command line flag. Repeating such a flag
// multiple times installs additional rules. You should use
// these rules to block outgoing traffic.
//
// You can also apply optional DNAT rules with `--dnat-rule`. Any
// time you repeat this flag you add a new rule. You should use
// these rules to hijack outgoing traffic towards proxies you
// control, which may apply additional blocking policies.
package main

import (
	"bytes"
	"log"
	"os"

	"github.com/bassosimone/getoptx"
	"golang.org/x/sys/execabs"
)

func main() {
	netns := NewNetnsScript()
	parser := getoptx.MustNewParser(netns)
	parser.MustGetopt(os.Args)
	cc := NewCommandConstructor(netns.DryRun)
	if len(parser.Args()) <= 0 || netns.Help {
		parser.PrintUsage(os.Stdout)
		os.Exit(0)
	}
	if netns.Gateway == "" {
		netns.Gateway = defaultGateway()
	}
	if netns.Workdir != "" {
		if err := os.Chdir(netns.Workdir); err != nil {
			log.Fatal(err)
		}
	}
	scr := netns.Build(cc, parser.Args())
	if err := scr.Run(); err != nil {
		log.Fatal(err)
	}
}

func defaultGateway() string {
	cmd := execabs.Command("ip", "route", "show", "default")
	output, err := cmd.Output()
	if err != nil {
		log.Fatal(err)
	}
	return string(bytes.Split(output, []byte(" "))[4])
}
