#!/bin/sh

# Script by Persian Prince for https://github.com/OpenVisionE2
# You're not allowed to remove my copyright or reuse this script without putting this header.

rm -rf Matze*
rm -rf *index*
rm -rf *enigma_2_*
rm -rf *enigma2-plugin-settings-matze-*

wget --wait=3 -i links.txt

for d in *.zip
do
  dir=./${d%%.zip}
  unzip -d "$dir" "$d"
done

rm -rf *.zip

rename -f 's/_[^_]*$//' */
rename -f 's/enigma_2_/enigma2-plugin-settings-matze-/' */

find . -name '*.xml*' -type f | xargs rm -f
find . -name '*.url*' -type f | xargs rm -f
find . -name '*_org*' -type f | xargs rm -f
find . -name '*.org*' -type f | xargs rm -f
find . -name '*_bak*' -type f | xargs rm -f
find . -name '*.bak*' -type f | xargs rm -f


setup_git() {
 git config --global user.email "bot@oe-alliance.com"
 git config --global user.name "enigma2-settings-feed build Bot"
 git config advice.addignoredfile false
}

commit_files() {
  git checkout main
  git add -u
  git add *
  git commit --message "Fetch latest Matze settings."
  ./CI/chmod.sh
  ./CI/dos2unix.sh
}

upload_files() {
  git remote add upstream https://${GITHUB_TOKEN}@github.com/oe-alliance/matze-settings.git > /dev/null 2>&1
  git push --quiet upstream main || echo "failed to push with error $?"
}

setup_git
commit_files
upload_files
