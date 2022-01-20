# shyml

Basic YAML parsing framework written in Bash

## Overview

Influenced by [this answer on stackoverflow](https://stackoverflow.com/a/21189044/15355689) this Bash script takes input configuration
files formatted in YAML and outputs a dictionary with the parsed fields and values for use in other scripts. This is useful for creating
wrappers for existing tools that have large and/or unintuitive CLI parameters where the inputs can easily be provided in a YAML file
instead with fields of the users liking

## Installation

Clone this repository

```
$ git clone https://github.com/gregfolker/shyml.git
```

Run the install script from the repository root

```
$ cd shyml/ && sudo ./install.sh
```

## Usage and Examples

### Basic Usage

`shyml` can be run alone but isn't very useful unless the output is stored off somewhere for use by something else

```
$ shyml [YAML FILE] (PREFIX)
(
['field']='value'
['field_subfield']='value'
)
```

### YAML File Format

Example YAML file:

```
---
## global definitions
global:
  debug: yes
  verbose: no
  debugging:
    detailed: no
    header: "debugging started"

## output
output:
  file: "yes"
```

A value only needs to be within double quotes `""` if it contains whitespace characters

The above `examples/example1.yaml` file will be parsed as the following:

```
$ shyml examples/example1.yaml
(
['global_debug']='yes'
['global_verbose']='no'
['global_debugging_detailed']='no'
['global_debugging_header']='debugging started'
['output_file']='yes'
)
```

See `examples/` for more example YAML files and supported formats

### Usage in Scripts

Typically, `shyml` is used as the front-end to another script in order to capture inputs from the user

Example of parsing field/value pairs into a local dictionary:

```
declare -A inputs=$(shyml "examples/example1.yaml")
```

To avoid needing to pass `inputs` all around the script, you can dynamically define environment variables as `FIELD='value'`
and make them available to child processes using `export`

```
for key in ${!inputs[@]} ; do
   export ${key^^}="${inputs[$key]}"
done
```

This will result in the following definitions globally available at runtime for the executing script:

```
GLOBAL_DEBUG=yes
GLOBAL_VERBOSE=no
GLOBAL_DEBUGGING_DETAILED='no'
GLOBAL_DEBUGGING_HEADER='debugging started'
OUTPUT_FILE=yes
```

### Custom Prefixes

Prefixes can optionally be added to the fields as the second argument to `shyml`, for example:

```
$ shyml examples/example1.yaml myprefix
(
['myprefix_global_debug']='yes'
['myprefix_global_verbose']='no'
['myprefix_global_debugging_detailed']='no'
['myprefix_global_debugging_header']='debugging started'
['myprefix_output_file']='yes'
)
```

## Limitations

At this time there are a few limitations with what `shyml` is able to parse. Pull requests are always welcome to add the necessary support
for the following items

- Field names containing whitespace characters are not supported
- Values defined as lists are not supported
- Duplicate field names are not supported

## Bug Reporting

Bugs are tracked using [Github](https://github.com/gregfolker/shyml/issues)
