#!/bin/bash
set -e

#make sure we have everything needed to do the setup
NEEDED_UTILS=( \
  "wget" \
  "unzip" \
  "tar" \
)
for util in ${NEEDED_UTILS[*]}
do
  command -v $util >/dev/null 2>&1 || { echo >&2 "I require $util but it's not installed.  Aborting."; exit 1; }
done

#Depending on the OS, figure out which chromedriver and phantomjs to download
#This hasnt been tested on windows, sooo....
if [[ "$OSTYPE" == "linux-gnu" ]]; then
  #is it 32 or 64 bit linux...
  MACHINE_TYPE=`uname -m`
  if [ ${MACHINE_TYPE} == 'x86_64' ]; then
    # 64-bit stuff here
    FilesToDownload=( \
      "https://chromedriver.storage.googleapis.com/2.31/chromedriver_linux64.zip" \
      "https://github.com/mozilla/geckodriver/releases/download/v0.18.0/geckodriver-v0.18.0-linux64.tar.gz" \
    )
  else
    # 32-bit stuff here
    FilesToDownload=( \
      "https://chromedriver.storage.googleapis.com/2.31/chromedriver_linux32.zip" \
      "https://github.com/mozilla/geckodriver/releases/download/v0.18.0/geckodriver-v0.18.0-macos.tar.gz" \
    )
  fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
  FilesToDownload=( \
    "https://chromedriver.storage.googleapis.com/2.31/chromedriver_mac64.zip" \
    "https://github.com/mozilla/geckodriver/releases/download/v0.18.0/geckodriver-v0.18.0-macos.tar.gz" \
  )
elif [[ "$OSTYPE" == "win32" ]]; then
  FilesToDownload=( \
    "https://chromedriver.storage.googleapis.com/2.31/chromedriver_win32.zip" \
    "https://github.com/mozilla/geckodriver/releases/download/v0.18.0/geckodriver-v0.18.0-win32.zip" \
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

# EXTRACT PLUGINS
pushd path_ext
shopt -s nullglob #need this for cases where no .tar.bz2 files
for p in tmp/*.zip; do unzip -n -q $p; done
for p in tmp/*.tar.bz2; do tar jxf $p; done
for p in tmp/*.tar.gz; do tar xzf $p; done
popd

echo "Setup successful"
