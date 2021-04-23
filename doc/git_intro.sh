# access the path u wanna put the folder in
cd ~/Desktop

# download project from github
# syntax: git clone website local_location
git clone https://github.com/lowspace/MAST90106.git

# access the folder, then we can use git command
cd ./MAST90106

# check git status
# REF: https://github.com/git-guides/git-status
git status

# add modified files into stage
# syntax: git add doc_name.suffiex
# REF: https://github.com/git-guides/git-add
git add README.md
# add folder: https://stackoverflow.com/questions/18248177/how-to-git-commit-a-whole-folder/38839318 
# remove file: https://stackoverflow.com/questions/6313126/how-to-remove-a-directory-from-git-repository

# commit the modified files into brach with ur message 
git commit -m "describe ur commit"

# pull before push
git pull

# push the modifications into the git file
git push

# if u meet the 403 error, try the following commands
# xxxx = ur socks5 port
git config --global http.proxy 'socks5://127.0.0.1:xxxx'
git config --global https.proxy 'socks5://127.0.0.1:xxxx'

# git remove all .DS_Store and .ipynb_checkpoints
find . -name .ipynb_checkpoints -print0 | xargs -0 git rm -r --ignore-unmatch
find . -name .DS_Store -print0 | xargs -0 git rm -f --ignore-unmatch

# how to ignore the files, such as .DS_Store and .ipynb_checkpoints, when committing?
# ref1: https://smlpoints.com/notes-git-ignore-ds_store-files-and-so-on-gitignore.html
# ref2: https://stackoverflow.com/questions/107701/how-can-i-remove-ds-store-files-from-a-git-repository

# how to check the configuration of git
vi ~/.gitconfig

