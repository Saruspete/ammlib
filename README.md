# Adrien' Modular Library

## Use Case

A huge number of scripts are used to do day2day production.
This is an attempt to provide a quality common library, that can be :
- usable in scripts **and** interactive shells
- modular: easy to extend, do not load every unneeded function
- fast: use native shell features instead of creating process
- secure: reduce the risk of typos and undefined behaviour, check return code
- fault-tolerant: protects itself against various env failures, sanitize inputs
- debuggable: helps keeping track of processing, especially during failures
- packable: generates a single file to be 


## General Requirements and targeted environment

### Target systems 
 - target shell: **bash4**
 - target Kernel: **Linux**
 - target Distribution (modular): RHEL 6+, Debian, Gentoo (and more )

While most libraries provides generic features only tied to the shell (or coreutils), some libraries are very tied to the Distribution: packages management, chroot generation, system configuration...

### Base structure

A template is available in [lib/_template](blob/master/lib/_template) file. You should always use it, and try to keep-up with upgrades.

The main library enforce some best practices:
- `set -o nounset` (or equivalent `set -u`): All variables must be declared.
- `set -o noclobber`: Truncating existing non-empty files must be explicit, so instead of `echo > file` you must use `echo >| file` 
- `LC_ALL=C`: avoids translation of commands messages, numeric and date format, string expansion and sorting. Test yourself:

- `PS4=' (${BASH_SOURCE##*/}::${FUNCNAME[0]:-main}::$LINENO)  '`: This provides a more readable output to follow when tracing with `set -x`:


- Although using bash, we should avoid "bash-only" keywords (like `declare`, `local` or `readonly`). declarations must be done using `typeset` to help portability
to other shells (dash, ksh, zsh).  
- Avoid using `typeset -n`: while it's very nice to avoid `eval`, it's not available in early releases of bash4.


## Naming Convention

The naming convention helps avoiding name collision and typos.

Almost all resources in the library are prefixed by "amm", in a format or another.

### Functions

Functions must be :
- Declared by the `function` keyword (and not suffixed by `()`)
- Prefixed by `amm` + the capitalized module name: eg `ammString` for module "string.lib"
- have a descriptive header in the Doxygen format


### Variables

The general shell convention is to write global variables in UPPERCASE and 
local variables (in functions) in lower or CamelCase.

- Library's internal global variables must be prefixed by `__AMM` + the module
name in uppercase + `_`
- Variables inside a function must be declared to fix their scope locally

Example: For a variable keeping track of logs, set in logs.lib
  typeset __AMMLOGS_LOGLINES=""


### Tests

All tests must be done using `[[` operator. 



#### Tabs and spaces

Tabs are meant to specify an indentation level, a logical separation between blocks of code.  it's up to the user to decide if he wants 2, 4, or any unusual number of spaces for the tabs.
Spaces are used to visually align similar lines to the human eye.

This logic alignment / human eye distinction keeps visual correct, and allows everyone to have it's choices respected. 

Also in bash, use of tabs allows to use the heredoc construct "<<-EOT"
The - before "EOT" signifiy "Remove all leading tabs when using the code block".
That allows to keep a correct indentation in the code, without having to output them or using parsing hacks.


Examples: 
``` bash
	case $var in
		val1)   doit     ;;
		val22)  dothis   ;;
		val441) doanother;;
		*)      showhelp ;;
	esac
```

```bash
	if [[ -n "$file" ]]
		cat >| "$file" <<-EOT
			This line will be left aligned
			  And this one will start with 2 spaces
			But all leading tabs will be stripped.
		EOT
	fi
```





## Extra: Pitfals and how to write them

### Locale impact character expansion and sorting results
```
$ export LC_ALL=en_US.utf8
$ ls /usr/bin/[G-H]*
/usr/bin/GET
/usr/bin/hash
/usr/bin/head
/usr/bin/HEAD
/usr/bin/host
/usr/bin/hostname
/usr/bin/hostnamectl
/usr/bin/htop
$ export LC_ALL=C
$ ls /usr/bin/[G-H]*
/usr/bin/GET
/usr/bin/HEAD
```

### Good use of PS4 for tracing

When you do a `set -x`, the shell uses the value of PS4. the main library enforces this variable to  
`PS4=' (${BASH_SOURCE##*/}::${FUNCNAME[0]:-main}::$LINENO)  '`

This generates an output like this :
```
 (ammtestfunc.sh::main::23)  libname=kernel
 (ammtestfunc.sh::main::25)  ammLibLoad kernel
 (ammlib::ammLibLoad::180)  typeset -i r=0
 (ammlib::ammLibLoad::182)  typeset libfile=
 (ammlib::ammLibLoad::183)  for libname in "$@"
 (ammlib::ammLibLoad::186)  ammLibIsSublib kernel
 (ammlib::ammLibIsSublib::118)  typeset libname=kernel
 (ammlib::ammLibIsSublib::119)  [[ kernel != \k\e\r\n\e\l ]]
 (ammlib::ammLibLoad::206)  for l in $__AMMLIB_LOADED
 (ammlib::ammLibLoad::208)  [[ kernel == \a\m\l\i\b ]]
  (ammlib::ammLibLoad::212)  ammLibLoadable kernel
  (ammlib::ammLibLoadable::138)  typeset -i r=0
  (ammlib::ammLibLoadable::140)  for libname in "$@"
  (ammlib::ammLibLoadable::141)  typeset libfile=kernel
  (ammlib::ammLibLoadable::144)  [[ -e kernel ]]
   (ammlib::ammLibLoadable::149)  ammLibLocate kernel
   (ammlib::ammLibLocate::84)  typeset libname=kernel
```