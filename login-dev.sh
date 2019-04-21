red="\033[0;31m"
green="\033[0;32m"
nc="\e[0m"
login()
{
	[ -z "$1" ] && local fshare_username=$1 || printf "Please input FShare username: "; read fshare_username
	[ -z "$2" ] && local fshare_password=$2 || printf "Please input FShare password: "; read fshare_password
	local fshare_api_key="L2S7R6ZMagggC5wWkQhX2+aDi467PPuftWUMRFSn"
	local fshare_login="https://api2.fshare.vn/api/user/login"
	local fshare_download_url="https://api2.fshare.vn/api/session/download"
	local fshare_login_template='{"app_key":"%s","user_email":"%s","password":"%s"}'
	local fshare_login_data=$(printf "$fshare_login_template" "$fshare_api_key" "$fshare_username" "$fshare_password")
	local fshare_login_result=$(curl -s $fshare_login -d $fshare_login_data)
	local fshare_login_status=$(echo $fshare_login_result | gawk 'match($0, /(Login successfully\!)/, group) {print group[1]}')
	if [ $fshare_login_status != "" ]
	then
		printf "${green}User ${fshare_username} login successfully! ${nc}\n"
		echo $fshare_login_result > ~/.fshare_login_result
	else
		printf "${red}User ${fshare_username} login failed! ${nc}\n" >&2
	fi
	return 1
}
login fshare_username fshare_password