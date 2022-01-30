package main

import (
	"fmt"
	"os"
)

// Script is a script to execute command.
type Script struct {
	// setup contains the setup commands.
	setup []Command

	// command contains the commands to actually run.
	command []Command

	// cleanup contains the cleanup commands.
	cleanup []Command
}

// AddSetupCommand adds a setup command.
func (s *Script) AddSetupCommand(cmd Command) {
	s.setup = append(s.setup, cmd)
}

// AddCommand adds a command to run.
func (s *Script) AddCommand(cmd Command) {
	s.command = append(s.command, cmd)
}

// AddCleanupCommand adds a cleanup command.
func (s *Script) AddCleanupCommand(cmd Command) {
	s.cleanup = append(s.cleanup, cmd)
}

// Run runs the script.
func (s *Script) Run() error {
	defer func() {
		for _, cleanup := range s.cleanup {
			s.run(cleanup) // ignore error and execute all of them
		}
	}()
	for _, setup := range s.setup {
		if err := s.run(setup); err != nil {
			return err
		}
	}
	for _, command := range s.command {
		if err := s.run(command); err != nil {
			return err
		}
	}
	return nil
}

func (s *Script) run(cmd Command) error {
	fmt.Fprintf(os.Stderr, "🐚%s\n", cmd.String())
	return cmd.Run()
}
