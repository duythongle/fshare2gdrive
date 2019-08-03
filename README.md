# fshare2gdrive
NodeJS script for direct uploading from FShare.vn to Google Drive without storing files locally.
> For deprecated bash script (download.sh and login.sh), please see [here](https://github.com/duythongle/fshare2gdrive/blob/0cead7f9229fe6e54b2e9e81add0f6da4bdf453b/README.md).

## Features

- Pipe upload to GDrive without storing file locally. No huge storage needed! (thanks to RClone rcat feature)

- Download whole FShare folder recursively with folder path preserved

- Download in parallel (NOT recommended) and Resumable (thanks to GNU Parallel --resume)

## Dependencies

1. [RClone](https://rclone.org)

```bash
# Install RClone
curl -s https://rclone.org/install.sh | sudo bash

# Login GDrive for RClone.
rclone config

```

Please see [RClone official documents support for Google Drive](https://rclone.org/drive/) for more details.

2. NodeJS 10+, [GNU Parallel](https://www.gnu.org/software/parallel/) and curl

``` bash
# Install dependencies on Ubuntu
sudo apt-get update && \
sudo apt-get install parallel curl -y && \
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash
```

## Usage

> This script is recommended to run on an unlimited bandwidth VPS or it will be getting costly over time

1. Install this script and login fshare

``` bash
# Download/update this script
# Rerun this command to update this script
curl -s https://raw.githubusercontent.com/duythongle/fshare2gdrive/master/fshare2gdrive.js | \
sudo tee /usr/local/bin/fshare2gdrive.js >/dev/null

# Make it executable
sudo chmod +x /usr/local/bin/fshare2gdrive.js

# Init login FShare
fshare2gdrive.js

```

> On the first time you login, it will ask for login FShare `username` and `password` then store login credentials to `$HOME/.creds` in PLAIN TEXT for later use. So use with caution!

2. Download single FShare FILE to GDrive

``` bash
fshare2gdrive.js "<fshare_file_url>" "<rclone_remote_name>" "<remote_folder_path>"

```

`<fshare_file_url>`: your fshare file link.

`<rclone_remote_name>`: your rclone remote name that you have configured in step 1

`<remote_folder_path>`: your remote folder path you want to upload to.
> Don't forget to double quote your parameters

E.g:

``` bash
# the command below will download "https://www.fshare.vn/file/XXXXXXXXXXX"
# and pipe upload to "rclone rcat gdrive-remote:/RClone Upload/"
fshare2gdrive.js "https://www.fshare.vn/file/XXXXXXXXXXX" "gdrive-remote" "/RClone Upload/"
```

3. Download whole FShare FOLDER to GDrive SYNCHRONOUSLY (one by one file) ***RECOMMENDED way***

``` bash
# Generate single file download commands list for later use store in "/tmp/commands_list"
fshare2gdrive.js \
"<fshare_folder_url>" "<rclone_remote_name>" "<remote_folder_path>" > /path/to/temp/commands_list

# then make use of gnu parallel to run all command (resumable)
# "parallel -j 1" will download synchronously (one by one file) RECOMMENDED!
# "parallel -j X" greater then 1 will download in parallel with X number of simultaneous jobs
parallel -j 1 --bar --resume --joblog /path/to/temp/fshare2gdrive/joblogs < /path/to/temp/commands_list

```

`<fshare_folder_url>`: your fshare file link.

`<rclone_remote_name>`: your rclone remote name that you have configured in step 1

`<remote_folder_path>`: your remote folder path you want to upload to.
> Use parallel download ONLY when you make sure all folders included subfolders are existed in remote folder path or rclone will create duplicated folders!

E.g:

``` bash
# Generate single file download commands list for later use
fshare2gdrive.js \
"https://www.fshare.vn/folder/XXXXXXXXXXX" "gdrive-remote" "/RClone Upload/" \
> /tmp/commands_list

# Start running all commands list to download
parallel -j 1 --bar --resume --joblog /tmp/fshare2gdrive.joblogs < /tmp/commands_list

```

> If you keep getting ssh timeout issue, please make use of [Tmux](https://hackernoon.com/a-gentle-introduction-to-tmux-8d784c404340) or [ssh config file](https://stackoverflow.com/questions/25084288/keep-ssh-session-alive)
