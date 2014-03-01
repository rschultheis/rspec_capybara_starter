#!/bin/bash
set -e
set -x

#Depending on the OS, figure out which chromedriver and phantomjs to download
#This hasnt been tested on windows, sooo....
if [[ "$OSTYPE" == "linux-gnu" ]]; then
  FilesToDownload=( \
    "http://chromedriver.storage.googleapis.com/2.9/chromedriver_linux32.zip" \
    "https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-1.9.7-linux-i686.tar.bz2" \
  )
elif [[ "$OSTYPE" == "darwin"* ]]; then
  FilesToDownload=( \
    "http://chromedriver.storage.googleapis.com/2.9/chromedriver_mac32.zip" \
    "https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-1.9.7-macosx.zip" \
  )
elif [[ "$OSTYPE" == "win32" ]]; then
  FilesToDownload=( \
    "http://chromedriver.storage.googleapis.com/2.9/chromedriver_win32.zip" \
    "https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-1.9.7-windows.zip" \
  )
else
  echo "Unable to detect your OS type"
  exit
fi


#make the directory where we'll keep the packages we download
mkdir -p "path_ext/tmp"

# GET PLUGINS
for download_url in ${FilesToDownload[*]}
do
  basename=${download_url##*/}
  file_path="path_ext/tmp/$basename"
  if [ ! -e $file_path ]
  then
    wget -x \
      -O $file_path \
      $download_url
  fi
done

pushd path_ext
shopt -s nullglob #need this for cases where no .tar.bz2 files
for p in tmp/*.zip; do unzip -n $p; done
for p in tmp/*.tar.bz2; do tar jxf $p; done
ln -sf phantomjs-1.9.7-macosx/bin/phantomjs .
popd

echo "Setup successful"
