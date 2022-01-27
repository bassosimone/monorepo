// Command run-workflow runs a workflow until completion.
package main

import (
	"errors"
	"fmt"
	"os"
	"path"
	"path/filepath"
	"strings"

	"github.com/bassosimone/getoptx"
	"github.com/mitchellh/go-wordwrap"
	"golang.org/x/sys/execabs"
	"gopkg.in/yaml.v3"
)

// logError logs an error message on the stderr.
func logError(err error, msg string) {
	fmt.Fprintf(os.Stderr, "😵%s: %s\n", msg, err.Error())
}

// exitOnError prints an error message and exits if err is not nil.
func exitOnError(err error, msg string) {
	if err != nil {
		logError(err, msg)
		os.Exit(1)
	}
}

// workflow describes a workflow.
type workflow struct {
	// Description is the human readable description.
	Description string `yaml:"description"`

	// Actions contains the workflow actions.
	Actions []action `yaml:"actions"`
}

// action describes an action.
type action struct {
	// Action is the name of the action to run. Actions are
	// files like ./tools/run.d/<workflow>/action.bash.
	Action string `yaml:"action"`

	// Env contains environment variables for the action itself.
	Env map[string]string `yaml:"env"`

	// Interactive indicates whether the action is interactive.
	Interactive bool
}

// flags contains command line flags.
type flags struct {
	// DryRun is the -n, --dry-run flag.
	DryRun bool `doc:"just print which actions will be executed" short:"n"`

	// Help is the -h, --help flag.
	Help bool `doc:"print this help message" short:"h"`

	// Skip is the -s, --skip <index> flag.
	Skip int `doc:"skip directly to the action with the given index" short:"s"`

	// Workdir is the -w, --workdir <dir> flag.
	Workdir string `doc:"use this already-existing working dir" short:"w"`
}

// showWorkflows shows the existing workflows.
func showWorkflows(rootPath string) {
	fmt.Printf("Workflows:\n")
	err := filepath.Walk(rootPath, func(filePath string, info os.FileInfo, err error) error {
		if err != nil {
			return err // this is stuff like "cannot read dir"
		}
		data, err := os.ReadFile(path.Join(filePath, "workflow.yml"))
		if err != nil {
			return nil // no workflow in there
		}
		var workflow workflow
		if err := yaml.Unmarshal(data, &workflow); err != nil {
			return err // cannot parse yaml file
		}
		fmt.Printf("  %s:\n", path.Base(filePath))
		fmt.Printf("\n")
		for _, line := range strings.Split(wordwrap.WrapString(workflow.Description, 72), "\n") {
			fmt.Printf("    %s\n", line)
		}
		return nil
	})
	exitOnError(err, "cannot show the list of workflows")
}

// runSpecificAction runs the given action with the given index in the
// context of the given workflow name and command line flags.
func runSpecificAction(flags *flags, workflowName string, idx int, action *action) {
	fmt.Fprintf(os.Stderr, "📌start action #%d: %s\n", idx, action.Action)
	runner := path.Join(".", "tools", "run-action", "run")
	cmd := execabs.Command(runner, action.Action)
	if action.Interactive {
		cmd.Stdin = os.Stdin
		cmd.Stdout = os.Stdout
		cmd.Stderr = os.Stderr
	} else {
		logfile := path.Join(flags.Workdir, "LOG.txt")
		logfp, err := os.OpenFile(logfile, os.O_APPEND|os.O_WRONLY|os.O_CREATE, 0644)
		exitOnError(err, "cannot create log file")
		fmt.Fprintf(os.Stderr, "🤓appending logs to %s\n", logfile)
		cmd.Stdout = logfp
		cmd.Stderr = logfp
		defer func() {
			err := logfp.Close()
			exitOnError(err, "cannot close logfile")
		}()
	}
	// The environment variables order is: (1) current environ, (2) user
	// variables, and (2) finally workdir directory. The last variable to
	// be set into the environment takes precedence over other previous
	// variables with the same name set into the environment.
	cmd.Env = os.Environ() // 1
	for key, value := range action.Env {
		variable := fmt.Sprintf("%s=%s", key, value)
		cmd.Env = append(cmd.Env, variable) // 2
	}
	cmd.Env = append(cmd.Env, fmt.Sprintf("workdir=%s", flags.Workdir)) // 3
	fmt.Fprintf(os.Stderr, "")
	if flags.DryRun {
		return
	}
	if err := cmd.Run(); err != nil {
		logError(err, "executing action failed")
		fmt.Fprintf(os.Stderr, "🤓restart with: ./tools/run -s%d -w%s %s\n",
			idx, flags.Workdir, workflowName)
		os.Exit(2)
	}
}

// runWorkflow runs the given workflow.
func runWorkflow(flags *flags, rootPath, workflowName string) {
	data, err := os.ReadFile(path.Join(rootPath, workflowName, "workflow.yml"))
	exitOnError(err, "cannot open yaml file")
	var workflow workflow
	err = yaml.Unmarshal(data, &workflow)
	exitOnError(err, "cannot parse yaml file")
	if flags.Workdir == "" {
		workdir, err := os.MkdirTemp("./output", "")
		exitOnError(err, "cannot create workdir directory")
		flags.Workdir = workdir
	}
	for idx, action := range workflow.Actions {
		if idx < flags.Skip {
			continue // user wants to skip to a subsequent action
		}
		runSpecificAction(flags, workflowName, idx, &action)
	}
}

func main() {
	var flags flags
	parser := getoptx.MustNewParser(&flags,
		getoptx.SetPositionalArgumentsPlaceholder("[workflowName]"))
	if err := parser.Getopt(os.Args); err != nil {
		logError(err, "cannot parse command line options")
		fmt.Fprintf(os.Stderr, "🤓use the --help flag for more help\n")
		os.Exit(1)
	}
	rootPath := path.Join(".", "tools", "run.d")
	if flags.Help || len(parser.Args()) <= 0 {
		parser.PrintUsage(os.Stdout)
		showWorkflows(rootPath)
		os.Exit(0)
	}
	if len(parser.Args()) > 1 {
		logError(errors.New("expected zero or one positional arguments"),
			"cannot parse command line options")
		fmt.Fprintf(os.Stderr, "🤓use the --help flag for more help\n")
		os.Exit(1)
	}
	workflowName := parser.Args()[0]
	runWorkflow(&flags, rootPath, workflowName)
}
