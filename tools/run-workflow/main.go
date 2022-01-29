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

	// Pipeline contains the workflow's pipeline.
	Pipeline []stage `yaml:"pipeline"`
}

// stage describes a pipeline stage.
type stage struct {
	// Action is the name of the action to run. Actions are
	// files like ./tools/run.d/<workflow>/action.bash.
	Action string `yaml:"action"`

	// Command is a command to run inline. It is a fatal error
	// to provide both Action and Command together.
	Command string `yaml:"command"`

	// Env contains environment variables for the action itself.
	Env map[string]string `yaml:"env"`

	// Interactive indicates whether the action is interactive.
	Interactive bool `yaml:"interactive"`
}

// flags contains command line flags.
type flags struct {
	// DryRun is the -n, --dry-run flag.
	DryRun bool `doc:"just print which actions or command would be executed" short:"n"`

	// Environ is the -E, --environ flag.
	Environ []string `doc:"override the value of the given workflow-specific environment variable (e.g., -E netem=\"delay 100ms\")" short:"E"`

	// Help is the -h, --help flag.
	Help bool `doc:"print either general usage (with no arguments) or workflow-specific info (e.g., ./tools/run --help <workflow>)" short:"h"`

	// Skip is the -s, --skip <index> flag.
	Skip int `doc:"skip directly to the action or command with the given index, ignoring the all previous ones (indexes start from zero)" short:"s"`

	// Workdir is the -w, --workdir <dir> flag.
	Workdir string `doc:"reuse the given already-existing working dir <dir> rather than creating a new random one inside ./output" short:"w"`
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
		fmt.Printf("  %s\n\n", path.Base(filePath))
		return nil
	})
	exitOnError(err, "cannot show the list of workflows")
}

// errBothActionAndCommand occurs when both Action and Command are set.
var errBothActionAndCommand = errors.New("both action and command are set")

// runSpecificStage runs the given action with the given index in the
// context of the given workflow name and command line flags.
func runSpecificStage(flags *flags, workflowName string, idx int, stg *stage) {
	fmt.Fprintf(os.Stderr, "📌start stage #%d\n", idx)
	runner := path.Join(".", "tools", "run-action", "run")
	if stg.Action != "" && stg.Command != "" {
		logError(errBothActionAndCommand, "cannot run this stage")
	}
	var cmd *execabs.Cmd
	if stg.Action != "" {
		cmd = execabs.Command(runner, stg.Action)
	} else {
		cmd = execabs.Command("bash", "-c", stg.Command)
	}
	if stg.Interactive {
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
	// variables in the yaml, (3) user variables from -E flags, and (4)
	// finally the workdir directory. The last variable to
	// be set into the environment takes precedence over other previous
	// variables with the same name set into the environment.
	cmd.Env = os.Environ() // 1
	for key, value := range stg.Env {
		variable := fmt.Sprintf("%s=%s", key, value)
		cmd.Env = append(cmd.Env, variable) // 2
	}
	cmd.Env = append(cmd.Env, flags.Environ...) // 3
	cmd.Env = append(
		cmd.Env, fmt.Sprintf("workdir=%s", flags.Workdir)) // 4
	fmt.Fprintf(os.Stderr, "🤓executing: %s", cmd)
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
	if flags.Help {
		fmt.Printf("\n%s:\n", workflowName)
		for _, line := range strings.Split(wordwrap.WrapString(workflow.Description, 72), "\n") {
			fmt.Printf("  %s\n", line)
		}
		return
	}
	if flags.Workdir == "" {
		workdir, err := os.MkdirTemp("./output", "")
		exitOnError(err, "cannot create workdir directory")
		flags.Workdir = workdir
	}
	for idx, action := range workflow.Pipeline {
		if idx < flags.Skip {
			continue // user wants to skip to a subsequent action
		}
		runSpecificStage(flags, workflowName, idx, &action)
	}
}

func main() {
	var flags flags
	parser := getoptx.MustNewParser(&flags,
		getoptx.SetPositionalArgumentsPlaceholder("[workflowName]"),
		getoptx.SetProgramName("./tools/run"))
	if err := parser.Getopt(os.Args); err != nil {
		logError(err, "cannot parse command line options")
		fmt.Fprintf(os.Stderr, "🤓use the --help flag for more help\n")
		os.Exit(1)
	}
	rootPath := path.Join(".", "tools", "run.d")
	if len(parser.Args()) > 1 {
		logError(errors.New("expected either zero or one positional arguments"),
			"cannot parse command line options")
		fmt.Fprintf(os.Stderr, "🤓use the --help flag for more help\n")
		os.Exit(1)
	}
	if len(parser.Args()) <= 0 || parser.Args()[0] == "help" {
		parser.PrintUsage(os.Stdout)
		showWorkflows(rootPath)
		os.Exit(0)
	}
	workflowName := parser.Args()[0]
	runWorkflow(&flags, rootPath, workflowName)
}
