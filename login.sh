#!/bin/bash
echo "Start logging in..."
fshare_login()
{
  local fshare_username=$1
  local fshare_password=$2
  local fshare_api_key="L2S7R6ZMagggC5wWkQhX2+aDi467PPuftWUMRFSn"
  local fshare_login="https://api2.fshare.vn/api/user/login"
  local fshare_download_url="https://api2.fshare.vn/api/session/download"
  local fshare_login_template='{"app_key":"%s","user_email":"%s","password":"%s"}'
  local fshare_login_data=$(printf "$fshare_login_template" "$fshare_api_key" "$fshare_username" "$fshare_password")
  local fshare_login_result=$(curl -s $fshare_login -d $fshare_login_data)
  local fshare_login_status=$(echo $fshare_login_result | gawk 'match($0, /(Login successfully\!)/, group) {print group[1]}')

  local red="\033[0;31m"
  local green="\033[0;32m"
  local nc="\e[0m"
  if [ "$fshare_login_status" != "" ]; then
    printf "\n${green}User ${fshare_username} login successfully! ${nc}\n"
    echo $fshare_login_result > ~/.fshare_login_result
    return 1
  else
    printf "\n${red}User ${fshare_username} login failed! ${nc}\n" >&2
    return 0
  fi
}
fshare_login $1 $2
