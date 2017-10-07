
typeset MYSELF="$(readlink -f $0)"
typeset MYPATH="${MYSELF%/*}"

# Load the main lib
. $MYPATH/../lib/lib

ammLibLoad proc log proc
