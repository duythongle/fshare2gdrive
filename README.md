# fshare2gdrive
Shell script for direct uploading from FShare.vn to Google Drive without storing files locally.

# Dependencies
This script denpend on bash, curl and gawk. Please install all of them first

e.g
``` bash
# Install on Ubuntu
sudo apt-get install bash, curl, gawk -y
```

# Usage
First login with command below

$ curl -s https://duythongle.github.io/fshare2gdrive/login.sh | bash -s `fshare_username` `fshare_password`
> It will store login credentials to ~/.fshare_login_result in plain text. So use with caution!

Then run download command

$ curl -s https://duythongle.github.io/fshare2gdrive/download.sh | bash -s `"fshare_file_url"` `"rclone_remote_name"` `"remote_folder_path"`

e.g
``` bash
# the command below will download "https://www.fshare.vn/file/XXXXXXXXXXX" and pipe upload to "rclone rcat gdrive-remote:/RClone Upload/"
curl -s https://duythongle.github.io/fshare2gdrive/download.sh | bash -s "https://www.fshare.vn/file/XXXXXXXXXXX" "gdrive-remote" "/RClone Upload/"
```

