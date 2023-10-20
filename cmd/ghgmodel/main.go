package main

import (
	"github.com/rs/zerolog/log"
	"github.com/tkennes/openghg/pkg/cmd"
)

func main() {
	// runs the appropriate application mode using the default ghgmodel command
	// see: github.com/tkennes/openghg/pkg/cmd package for details
	if err := cmd.Execute(nil); err != nil {
		log.Fatal().Err(err)
	}
}
