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
      "http://chromedriver.storage.googleapis.com/2.9/chromedriver_linux64.zip" \
      "https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-1.9.7-linux-x86_64.tar.bz2" \
    )
  else
    # 32-bit stuff here
    FilesToDownload=( \
      "http://chromedriver.storage.googleapis.com/2.9/chromedriver_linux32.zip" \
      "https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-1.9.7-linux-i686.tar.bz2" \
    )
  fi
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
PhantomJSExecutable=$( find . -path './phantomjs*/bin/phantomjs')
ln -sf $PhantomJSExecutable .
popd

echo "Setup successful"
