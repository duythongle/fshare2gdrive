# fshare2gdrive
Shell script for direct uploading from FShare.vn to Google Drive without storing files locally.

# Dependencies
This script denpend on bash, curl and gawk. Please install all of them first. E.g:
``` bash
# Install on Ubuntu
sudo apt-get install bash, curl, gawk -y
```

# Usage
> This script is recommended to run on an unlimited bandwidth VPS or it will be getting costly over time
1. Install and login gdrive with rclone
```bash
# Install rclone
curl https://rclone.org/install.sh | sudo bash
# Login
rclone config
```
Please see [RClone official documents support for Google Drive](https://rclone.org/drive/) for more details.

2. Login FShare via command below with your "fshare_username" and "fshare_password"
```bash
curl -s https://duythongle.github.io/fshare2gdrive/login.sh | bash -s "fshare_username" "fshare_password"
```
> It will store login credentials to ~/.fshare_login_result in plain text. So you only need to run it once and use with caution!

3. Then run download command

```bash
curl -s https://duythongle.github.io/fshare2gdrive/download.sh | bash -s "fshare_file_url" "rclone_remote_name" "remote_folder_path"
```
`"fshare_file_url"`: your fshare file link.

`"rclone_remote_name"`: your rclone remote name that you have configured in step 1

`"remote_folder_path"`: your remote folder path you want to upload to.

E.g:
``` bash
# the command below will download "https://www.fshare.vn/file/XXXXXXXXXXX" and pipe upload to "rclone rcat gdrive-remote:/RClone Upload/"
curl -s https://duythongle.github.io/fshare2gdrive/download.sh | bash -s "https://www.fshare.vn/file/XXXXXXXXXXX" "gdrive-remote" "/RClone Upload/"
```

