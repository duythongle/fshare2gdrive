fshare_download() {
  local fshare_file_url=$1
  local rclone_remote_name=$2
  local remote_folder_path=$3

  local fshare_download_api="https://api2.fshare.vn/api/session/download"
  local fshare_login_result=$(cat ~/.fshare_login_result)
  local fshare_token=$(echo $fshare_login_result | gawk 'match($0, /"token"\:"(\w+)"/, group) {print group[1]}')
  local fshare_session_id=$(echo $fshare_login_result | gawk 'match($0, /"session_id"\:"(\w+)"/, group) {print group[1]}')
  local fshare_download_template='{"url":"%s","token":"%s","password":""}'
  local fshare_download_data=$(printf "$fshare_download_template" "$fshare_file_url" "$fshare_token")
  echo $fshare_download_data
  echo $fshare_session_id
  local extracted_download_url=$(curl -s -4 $fshare_download_api \
    -H 'Cookie: session_id='$fshare_session_id \
    -H 'Accept-Encoding: gzip, deflate, br' \
    -H 'Content-Type: application/json' \
    -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36' \
    -d $fshare_download_data --compressed | gawk 'match($0, /"location"\:"(.+?)"/, group) {print group[1]}')
  local download_file_name=$(echo $extracted_download_url | gawk 'match($0, /.+\/(.+?)$/, group) {print group[1]}')
  curl -s $extracted_download_url | \
    rclone rcat $rclone_remote_name:$remote_folder_path$download_file_name
}
fshare_download $1 $2 $3