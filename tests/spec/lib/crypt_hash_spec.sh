# shellcheck shell=bash

Describe "crypt.hash.lib"
	Include "../ammlib"
	Before "ammLib::Require crypt crypt.hash"


	Describe "String identification"
		Describe "ammCryptHash::TypeOf"
			Parameters
				# Taken from https://en.wikipedia.org/wiki/Crypt_(C)
				#"crypt_des"      'Kyq4bCxAXJkbg'
				#"crypt_bsdi"     '_EQ0.jzhSVeUyoSqLupI'
				"crypt_md5"      '$1$etNnh7FA$OlM7eljE/B7F1J4XYNnk81'
				"crypt_bcrypt"   '$2a$10$VIhIOofSMqgdGlL4wzE//e.77dAQGqntF/1dT7bqCrVtquInWy2qi'
				"crypt_nthash"   '$3$$8846f7eaee8fb117ad06bdd830b7586c'
				"crypt_sha256"   '$5$9ks3nNEqv31FX.F$gdEoLFsCRsn/WRN3wxUnzfeZLoooVlzeF4WjLomTRFD'
				"crypt_sha512"   '$6$qoE2letU$wWPRl.PVczjzeMVgjiA8LLy2nOyZbf7Amj3qLIL978o18gbMySdKZ7uepq9tmMQXxyTIrS12Pln.2Q/6Xscao0'
				"crypt_sha1"     '$sha1$40000$jtNX3nZ2$hBNaIXkt4wBI2o5rsi8KejSjNqIq'
				"crypt_sunmd5"   '$md5,rounds=5000$GUBv0xjJ$$mSwgIswdjlTY0YxV7HBVm0'
				"crypt_yescrypt" '$y$j9T$F5Jx5fExrKuPp53xLKQ..1$X3DX6M94c7o.9agCG9G317fhZg9SqC.5i5rd.RhAtQ7'
			End
			Example "Type of $2"
				When call ammCryptHash::TypeOf "$2"
				The output should eq "$1"
			End
		End
	End

	Describe "Hash validation"
		Describe "ammCryptHash::Check"
			Parameters
				'crypt_md5'    'totopouet'  '$1$MVC$JGvvxV8XDgi0x/eKs.7Rd0'
				'crypt_sha256' 'totopouet'  '$5$MVC$Gq31moV16rZwJPpbrTHD8LWP3s2lzCIWihKCN1qFYYC'
				'crypt_sha512' 'totopouet'  '$6$MVC$8po7Z2WEBWJrlqHpcoK.WKPqZnthfDKpLCc0OLe0BUQVIcnKnQ/9ZkqqM/gq/NwQ/ExAsarBY5vCQLu/8ySVX0'
				'crypt_apr1'   'totopouet'  '$apr1$MVC$vPhbYDGrEmlwKZscjPlTf/'
				'apache_sha1'  'totopouet'  '{SHA}a618693d1df452bcb9631da08e985a23a2973ac0'
			End
			Example "Check hash match with method $1"
				When call ammCryptHash::Check "$3" "$2"
				The status should be success
			End
			Example "Check hash generation with method $1"
				When call ammCryptHash::Generate "$2" "$1" "MVC"
				The output should eq "$3"
			End
		End
	End
End
