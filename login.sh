red="\033[0;31m"
green="\033[0;32m"
nc="\e[0m"
fshare_username=$1
fshare_password=$2
fshare_api_key="L2S7R6ZMagggC5wWkQhX2+aDi467PPuftWUMRFSn"
fshare_login="https://api2.fshare.vn/api/user/login"
fshare_download_url="https://api2.fshare.vn/api/session/download"
fshare_login_template='{"app_key":"%s","user_email":"%s","password":"%s"}'
fshare_login_data=$(printf "$fshare_login_template" "$fshare_api_key" "$fshare_username" "$fshare_password")
fshare_login_result=$(curl -s $fshare_login -d $fshare_login_data)
fshare_login_status=$(echo $fshare_login_result | gawk 'match($0, /(Login successfully\!)/, group) {print group[1]}')
if [ "$fshare_login_status" != "" ]; then 
	printf "${green}User ${fshare_username} login successfully! ${nc}\n"
	echo $fshare_login_result > ~/.fshare_login_result
else
	printf "${red}User ${fshare_username} login failed! ${nc}\n" >&2
fi
