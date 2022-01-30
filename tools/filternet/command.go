package main

import (
	"os"

	"golang.org/x/sys/execabs"
)

// NewCommandConstructor creates a new command constructor
// whose behavior depends on dryRun flag.
func NewCommandConstructor(dryRun bool) CommandConstructor {
	switch dryRun {
	case true:
		return &dryCommandConstructor{}
	default:
		return &normalCommandConstructor{}
	}
}

type dryCommandConstructor struct{}

func (*dryCommandConstructor) NewCommand(program string, args ...string) Command {
	return &dryCommand{
		program: program,
		args:    args,
	}
}

func (*dryCommandConstructor) NewWriteLine(textLine, path string) Command {
	return &dryCommand{
		program: "echo",
		args:    []string{textLine, ">", path},
	}
}

type dryCommand struct {
	program string
	args    []string
}

func (cmd *dryCommand) Run() error {
	return nil // pretend everything is WAI
}

func (cmd *dryCommand) String() string {
	// let's reuse the implementation of execabs.Command
	inner := execabs.Command(cmd.program, cmd.args...)
	return inner.String()
}

type normalCommandConstructor struct{}

func (*normalCommandConstructor) NewCommand(program string, args ...string) Command {
	cmd := execabs.Command(program, args...)
	cmd.Stdin = os.Stdin
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	return cmd
}

func (*normalCommandConstructor) NewWriteLine(textLine, path string) Command {
	return &writeLineCommand{
		textLine: textLine,
		path:     path,
	}
}

type writeLineCommand struct {
	textLine string
	path     string
}

func (wf *writeLineCommand) Run() error {
	line := wf.textLine + "\n"
	return os.WriteFile(wf.path, []byte(line), 0644)
}

func (wf *writeLineCommand) String() string {
	inner := (&dryCommandConstructor{}).NewWriteLine(wf.textLine, wf.path)
	return inner.String()
}
