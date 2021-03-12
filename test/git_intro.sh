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

# commit the modified files into brach with ur message 
git commit -m "Wei"

# pull before push
git pull

# push the modifications into the git file
git push

# if u meet the 403 error, try the following commands
# xxxx = ur socks5 port
git config --global http.proxy 'socks5://127.0.0.1:xxxx'
git config --global https.proxy 'socks5://127.0.0.1:xxxx'