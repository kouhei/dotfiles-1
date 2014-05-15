function random_cowsay() {
	# /usr/local/Cellar/cowsay/3.03/share/cows
	COWS=$(readlink -f $(which cowsay))/../../share/cows
	NBRE_COWS=$(ls -1 $COWS | wc -l)
	COWS_RANDOM=$(expr $RANDOM % $NBRE_COWS + 1)
	COW_NAME=$(ls -1 $COWS | awk -F\. -v COWS_RANDOM_AWK=$COWS_RANDOM 'NR == COWS_RANDOM_AWK {print $1}')

	if grep -w "COWSAY_USE" ~/.bashrc >/dev/null; then
		#COW_NAME=`awk -F":" '/COWSAY_USE/{print $2}' ~/.bashrc`
		COW_NAME=$(grep -w "COWSAY_USE" ~/.bashrc | cut -d: -f2)
	else
		COW_NAME=$(ls -1 $COWS | awk -F\. -v COWS_RANDOM_AWK=$COWS_RANDOM 'NR == COWS_RANDOM_AWK {print $1}')
	fi

	cowsay -f $COW_NAME "`Fortune -s`"
}

function nowon() {
	[ -x ~/.bash.d/bin/readlink ] || return 1
	if which fortune cowsay >/dev/null; then
		while :
		do
			random_cowsay 2>/dev/null && break
		done
	fi && unset random_cowsay
	LANG=C
	echo -e  "\033[33m$(date +'%Y/%m/%d %T')\033[m"
	echo -en "\n"; sleep 0.5; pwd; ls
	echo -en "\n"
}

function _refuge_complement() {
	local curw prev

	COMPREPLY=()
	curw=${COMP_WORDS[COMP_CWORD]}
	prev=${COMP_WORDS[COMP_CWORD-1]}

	if [[ "$curw" == -* ]]; then
		COMPREPLY=( $( compgen -o default -W '-X -h --help --version --except' -- $curw ) )
	elif [[ "$prev" = "-X" || "$prev" = "--except" && $COMP_CWORD = 2 ]]; then
		COMPREPLY=( $( compgen -W '`\ls -AF ~/Dropbox/usr/init/unix/rc.d`' -- $curw ))
	fi

	return 0
}
complete -F _refuge_complement refuge

function _salvage_complement() {
	local curw prev

	COMPREPLY=()
	curw=${COMP_WORDS[COMP_CWORD]}
	prev=${COMP_WORDS[COMP_CWORD-1]}

	if [[ "$curw" == -* ]]; then
		COMPREPLY=( $( compgen -o default -W '-h --help -t --target -n --number -d --depth -c --ctime' -- $curw ) )
	elif [[ "$prev" = "-t" || "$prev" = "--target" ]]; then
		COMPREPLY=( $( compgen -W 'vim bak debris' -- $curw ))
	elif [[ $COMP_CWORD = $(($# - 1)) ]]; then
		COMPREPLY=( $( compgen -W '`\ls -F ~`' -- $curw ))
	fi

	return 0
}
complete -F _salvage_complement salvage

function _todrop_complement() {
	local curw prev

	COMPREPLY=()
	curw=${COMP_WORDS[COMP_CWORD]}
	prev=${COMP_WORDS[COMP_CWORD-1]}

	if [[ "$curw" == -* ]]; then
		COMPREPLY=( $( compgen -o default -W '-h --help --version -c --copy -f --force -v --verbose -p --path \
			-a --append -- -' -- $curw ) )
	elif [[ "$prev" = "-p" || "$prev" = "--path" ]]; then
		COMPREPLY=( $( compgen -W '`\ls -F ~/Dropbox`' "$curw" ))
	else
		COMPREPLY=( $( compgen -f $curw ) )
	fi

	return 0
}
complete -F _todrop_complement todrop

mkdir ()
{
	for arg do
		if [ -e "$arg" ]; then
			command mkdir -p "${arg}.d"
		else
			command mkdir -p "${arg}"
		fi
	done
}

calc(){ awk "BEGIN{ print $* }" ;}
