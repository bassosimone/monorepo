package main

// Command is a prepared command.
type Command interface {
	// String returns a string representation of the command
	// line that will be executed by this command.
	String() string

	// Run runs the command.
	Run() error
}

// CommandConstructor allows to construct commands.
type CommandConstructor interface {
	// NewCommand creates a new command.
	NewCommand(program string, args ...string) Command

	// NewWriteLine creates a command that writes a line of
	// text into the given file.
	NewWriteLine(textLine, path string) Command
}
