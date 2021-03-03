# Bash Modular Library

## Use Case

A huge number of scripts are used to do day2day production.
This is an attempt to provide a quality common library, that can be :
- usable in scripts **and** interactive shells
- modular: easy to extend, do not load every unneeded function
- fast: use native shell features instead of creating process
- secure: reduce the risk of typos and undefined behaviour, check return code
- fault-tolerant: protects itself against various env failures, sanitize inputs
- debuggable: helps keeping track of processing, especially during failures
- packable: generates a single packed script with the required modules for embbedding


## Why such a huge library in shell ?

The most often heard misconception is *if your shell script is more than 100 lines, you should switch to another langage*.
This is mostly because people don't read the man, don't check the underlying rules of a langage, and have a lazyness bias.

The shell is the most common langage on any machine, created to call other executables and parsing strings.
Because of its old age, availability and simplicity, its defaults differs from what we would expect from our moderns langages: if you think you must prefix your variables with the function name, it's because you don't declare them with "typeset" or "declare", which give them global visibility.

There's a few of these habits to get, and you'll see bash is just like any other scripting langage.

I wouldn't use Shell to create a web server, and I wouldn't use python or perl to call many other executables.


## General Requirements and targeted environment

### Target systems
 - target shell: **bash4.2** ([see available features](https://wiki-dev.bash-hackers.org/scripting/bashchanges))
 - target Kernel: **Linux**
 - target Distribution (modular): RHEL 7+, Debian, Gentoo (and more )

While most libraries provides generic features only tied to the shell (or coreutils), some libraries are very tied to the Distribution: packages management, chroot generation, system configuration...

### Base structure

A template is available in [lib/_template](blob/master/lib/_template) file. You should always use it, and try to keep-up with upgrades.

The main library enforce some best practices:
- `set -o nounset` (or equivalent `set -u`): All variables must be declared.
- `set -o noclobber`: Truncating existing non-empty files must be explicit, so instead of `echo > file` you must use `echo >| file` 
- `LC_ALL=C`: avoids translation of commands messages, numeric and date format, string expansion and sorting. Test yourself:

- `PS4=' (${BASH_SOURCE##*/}:$LINENO ${FUNCNAME[0]:-main})  '`: This provides a more readable output to follow when tracing with `set -x`:


- Although using bash, we should avoid "bash-only" keywords (like `declare`, `local` or `readonly`). declarations must be done using `typeset` to help portability
to other shells (dash, ksh, zsh).  
- Avoid using `typeset -n`: while it's very nice to avoid `eval`, it's not available in early releases of bash4.


## Naming Convention

The naming convention helps avoiding name collision and typos.

Almost all resources in the library are prefixed by "amm", in a format or another.

For general ideas on how to write shell scripts, please [have a look to my guide for production bash scripting](https://docs.google.com/presentation/d/1a4IAux4tNo7F7mQ6fbzIVPEHxQQ0buD15Cm8vSMJFb0/edit).

### Functions

Functions must be :
- Declared by the `function` keyword (and not suffixed by `()`)
- Prefixed by `amm` + the capitalized module name + `::`: eg `ammString::myfunc` for function `myfunc` in  module `string.lib`
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
Do not use the old idiom `[ x$var = x ]`, prefer the more readable `[[ -n "$var" ]]` (non empty) or its counterpart `[[ -z "$var" ]]` (empty)

### Strings

All strings must be enclosed with double quotes `"`. This is to allow variable expansion, and protext special chars.
If you want to use a special char or syntax, you simply close the double quote, and reopen it after.

```bash
typeset base=/sys/class/net/
typeset iface=lo

typeset tmppath
for tmppath in "$base/"*; do
	if [[ "${tmppath##*/}" == "$iface" ]]; then
		echo "Iface $iface found !"
	fi
done
```

Alternatively, you can use `compgen -G` to explicitely expand a glob pattern:

```bash
typeset ifacePath
for ifacePath in $(compgen -G "/sys/class/net/*"); do
    echo "${ifacePath##*/}"
done
```

#### Tabs and spaces

Tabs are meant to specify an indentation level, a logical separation between blocks of code.  it's up to the user to decide if he wants 2, 4, or any unusual number of spaces for the tabs.
Spaces are used to visually align similar lines to the human eye.

This logic / human eye distinction keeps visual alignment correct, and allows everyone to have it's choices respected. 

Also in bash, use of tabs allows to use the heredoc construct `<<-EOT`
The `-` before `EOT` signifiy "Remove all leading tabs when using the code block".
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





## Extra: Pitfals and how to avoid them

### Variable scope leak when vars are not typeset'd

By default, variables are global. You must use a keyword like `typeset`, `declare`, `local` or `readonly` to declare
its scope to be limited within the defining function.

```bash
var1="global"
var2="global"
function f1 { var1="local"; }
function f2 { typeset var2="local"; }
f1 ; f2
echo "var1=$var1 var2=$var2"
```

Even when using loops, you must declare the variables before:
```bash
typeset arg
for arg in "$@"; do
	: # Do something
done
```

### Testing if a value exists with 'set -o nounset' enabled
With `set -o nounset` you cannot access a variable not previously declared. This is also true for function arguments.

To workaround this, we'll use the default value: `${var:-default}`

```bash
function multiply {
	typeset v1="${1:-}"
	typeset v2="${2:-$v1}"

	if [[ -n "$v1" ]]; then
		echo $(( $v1 * $v2 ))
		return 0
	else
		return 1
	fi
}
```

### Testing if an array key exists with 'set -o nounset' enabled

The easiest idiom for this is using a subshell + disabling set -o :
```bash
typeset -A array=([banana]="yellow" [apple]="red")
# this will fail due to "set -o nounset", even with a default value
[[ -n "${array[pear]}" ]]
# So disable it in a subshell
( set +u; [[ -n "${array[pear]}" ]] )
```

### Copying an array

When copying an array, if you don't care about Index values, just copy it directly:

```bash
typeset -a arrSrc=("hello world" "Houson we got a problem" "there" "there")
typeset -a arrDst=("${arraySrc[@]}")
```

If you care about index, do the following:
```bash
typeset -a arrSrc=("" "hello world" "hey" "bien le bonjour")
typeset -a arrDst=($(ammEnv::VarExport arrSrc|cut -d'=' -f2-)
for a in "${!arrDst[@]}"; do echo "$a => '${arrDst[$a]}'"; done

# Will output:
# 0 => ''
# 1 => 'hello world'
# 2 => 'hey'
# 3 => 'bien le bonjour'
```

If you want to return an array from a function, you must create a special format:

```bash
function testFunc {
	typeset -a arrSrc=("hello world" "hey" "bien le bonjour")
	echo "(";
	for id in "${!arrSrc[@]}"; do
		echo "[$id]='${arrSrc[$id]}' "
	done
	echo ")"
}
typeset -a arrDst=$(testFunc)
for a in "${!arrDst[@]}"; do echo "$a => '${arrDst[$a]}'"; done

# Will output as expected:
# 0 => 'hello world'
# 1 => 'hey'
# 2 => 'bien le bonjour'
```

Or you can just use the provided helper `ammEnv::VarReturnArray varname`:
```bash
function testFunc {
	typeset -a arrSrc=("hello world" "hey" "bien le bonjour")
	ammEnv::VarReturnArray arrSrc
}
```


### Locale impact character expansion and sorting results
```shell
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

`PS4=' (${BASH_SOURCE##*/}:$LINENO ${FUNCNAME[0]:-main})  '`

- The first char of PS4 (default `+`) will be repeated to the current call depth. A space makes a clean visual indent
- `${BASH_SOURCE##*/}` is the file name of the currently processed file (leading folders being removed for conciseness)
- `$LINENO` is the current line number. Use `$BASH_LINENO` if you want to get the caller line
- `${FUNCNAME[0]:-main}` is the current function name, or `main` if not in a function
- `  ` 2 space to make a visual separation between this header and the code being executed

This generates an output like this :
```
 (ammtestfunc.sh:23 main)  libname=kernel
 (ammtestfunc.sh:25 main)  ammLibLoad kernel
 (ammlib:180 ammLib::Load)  typeset -i r=0
 (ammlib:182 ammLib::Load)  typeset libfile=
 (ammlib:183 ammLib::Load)  for libname in "$@"
 (ammlib:186 ammLib::Load)  ammLibIsSublib kernel
 (ammlib:118 ammLib::IsSublib)  typeset libname=kernel
 (ammlib:119 ammLib::IsSublib)  [[ kernel != \k\e\r\n\e\l ]]
 (ammlib:206 ammLib::Load)  for l in $__AMMLIB_LOADED
 (ammlib:208 ammLib::Load)  [[ kernel == \a\m\l\i\b ]]
  (ammlib:212 ammLib::Load)  ammLibLoadable kernel
  (ammlib:138 ammLib::Loadable)  typeset -i r=0
  (ammlib:140 ammLib::Loadable)  for libname in "$@"
  (ammlib:141 ammLib::Loadable)  typeset libfile=kernel
  (ammlib:144 ammLib::Loadable)  [[ -e kernel ]]
   (ammlib:149 ammLib::Loadable)  ammLibLocate kernel
   (ammlib:84 ammLib::Locate)  typeset libname=kernel
```
Where you can clearly see the file:line being executed, the function it is in, and the code being executed.

## Extra naming convension for modules functions

### Execution

For process wrappers, we split the tasks in 3 different functions.
Take the example of a network traceroute: `ammNetworkTraceroute`
- `ammNetwork::TracerouteCmd` returns the command line to be used
- `ammNetwork::TracerouteParse` parses the output of the command and returns variables, usable from `eval`
- `ammNetwork::Traceroute` is a helper using the Parse function and returns a quick and usable result

This split allows to extend process execution with process library, that provides timeout, parallelism, multi-users and other features...

