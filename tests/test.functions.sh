
glbref="global"
glbtst="global"
ovrref="global"
ovrtst="global"
typeset typref="global"
typeset typtst="global"


function func1 {
	
	echo "++ func1: glb:$glbref typ:$typref ovr:$ovrref"
	glbtst="func1"
	typtst="func1"
	typeset ovrtst="func1"
	typeset typloc="func1"
	ovrloc="func1"
}

func2 () {
	echo "++ func2: glb:$glbref typ:$typref ovr:$ovrref"
	glbtst="func2"
	typtst="func2"
	typeset ovrtst="func2"
	typeset typloc="func2"
	ovrloc="func2"
}

# Test 1
echo "== global: glb:$glbtst typ:$typtst ovr:$ovrtst loctyp:$typloc locovr=$ovrloc"
func1
echo "== global: glb:$glbtst typ:$typtst ovr:$ovrtst loctyp:$typloc locovr=$ovrloc"
echo

# Reset
glbtst="global"
typeset typtst="global"
ovrtst="global"


echo "== global: glb:$glbtst typ:$typtst ovr:$ovrtst loctyp:$typloc locovr=$ovrloc"
func2
echo "== global: glb:$glbtst typ:$typtst ovr:$ovrtst loctyp:$typloc locovr=$ovrloc"
