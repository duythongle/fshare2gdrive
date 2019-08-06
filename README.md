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
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash && \
sudo apt install -y nodejs
```

## Usage

> This script is recommended to run on an unlimited bandwidth VPS or it will be getting costly over time

1. Login fshare

``` bash
# Login FShare
curl -sS https://raw.githubusercontent.com/duythongle/fshare2gdrive/master/fshare2gdrive.js | \
tail -n+2 | node - login "your_fshare_email" "your_fshare_password"

```
> You only need to login once. Login credentials will save to `$HOME/.creds` in PLAIN TEXT for later use. So use with caution!

2. Download single FShare FILE to GDrive

``` bash
curl -sS https://raw.githubusercontent.com/duythongle/fshare2gdrive/master/fshare2gdrive.js | \
tail -n+2 | node - "<fshare_file_url>" "<rclone_remote_name>" "<remote_folder_path>" | bash -s

```

`<fshare_file_url>`: your fshare file link.

`<rclone_remote_name>`: your rclone remote name that you have configured in step 1

`<remote_folder_path>`: your remote folder path you want to upload to.
> Don't forget to double quote your parameters

E.g:

``` bash
# the command below will download "https://www.fshare.vn/file/XXXXXXXXXXX"
# and pipe upload to "rclone rcat gdrive-remote:/RClone Upload/"
curl -sS https://raw.githubusercontent.com/duythongle/fshare2gdrive/master/fshare2gdrive.js | \
tail -n+2 | node - "https://www.fshare.vn/file/XXXXXXXXXXX" "gdrive-remote" "/RClone Upload/"
```

3. Download whole FShare FOLDER to GDrive SYNCHRONOUSLY (one by one file) ***RECOMMENDED way***

``` bash
# Generate single file download commands list for later use to a file "/path/to/temp/commands_list"
curl -sS https://raw.githubusercontent.com/duythongle/fshare2gdrive/master/fshare2gdrive.js | \
tail -n+2 | node - "<fshare_folder_url>" "<rclone_remote_name>" "<remote_folder_path>" | bash -s

```

`<fshare_folder_url>`: your fshare file link.

`<rclone_remote_name>`: your rclone remote name that you have configured in step 1

`<remote_folder_path>`: your remote folder path you want to upload to.

E.g:

``` bash
# Generate single file download commands list and run one by one
curl -sS https://raw.githubusercontent.com/duythongle/fshare2gdrive/master/fshare2gdrive.js | \
tail -n+2 | node - \
"https://www.fshare.vn/folder/XXXXXXXXXXX" "gdrive-remote" "/RClone Upload/" | bash -s

```

You can make use of GNU Parallel to download in multiple simultaneous jobs as example below ***NOT recommended way!!!***

``` bash
# Generate single file download commands list for later use to a file "/tmp/commands_list"
curl -sS https://raw.githubusercontent.com/duythongle/fshare2gdrive/master/fshare2gdrive.js | \
tail -n+2 | node - "https://www.fshare.vn/folder/XXXXXXXXXXX" "gdrive-remote" "/RClone Upload/" \
> /tmp/commands_list

# Start running all commands list to download in parallel with resumable
# download jobs will run in 2 simultaneous jobs with "-j 2"
parallel -j 2 --bar --resume --joblog /tmp/fshare2gdrive.joblogs < /tmp/commands_list

```

> Use parallel download "parallel -j 2" or greater ONLY when you make sure all folders included subfolders are existed in remote folder path or rclone will create duplicated folders!
> If you keep getting ssh timeout issue, please make use of [Tmux](https://hackernoon.com/a-gentle-introduction-to-tmux-8d784c404340) or [ssh config file](https://stackoverflow.com/questions/25084288/keep-ssh-session-alive)
