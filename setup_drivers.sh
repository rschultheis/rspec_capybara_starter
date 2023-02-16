#!/bin/bash
set -e

# SETUP WEBDRIVER UTILITIES
#
# Install chromedriver and geckodriver (and other drivers if needed).
# These command line programs are needed to run webdriver tests on Chrome and Firefox.
#
# The programs are put into a "path_ext" subfolder.
# The test suite will prepend "path_ext" to $PATH, ensuring these drivers are used during test execution.
# This way of installing into local subfolder is non-intrusive to the rest of the system

# Subfolder to place utilities into
PathExt="path_ext"


# base paths for the drivers to download
# ChromeDriver: https://chromedriver.chromium.org/downloads
ChromeDriverBasePath="https://chromedriver.storage.googleapis.com/110.0.5481.77/chromedriver_"
# GeckoDriver for Firefox: https://github.com/mozilla/geckodriver/releases
GeckoDriverBasePath="https://github.com/mozilla/geckodriver/releases/download/v0.32.2/geckodriver-v0.32.2-"

# make sure we have everything needed to do the setup
NEEDED_UTILS=( \
  "wget" \
  "unzip" \
  "tar" \
)
for util in ${NEEDED_UTILS[*]}
do
  command -v $util >/dev/null 2>&1 || { echo >&2 "I require $util but it's not installed.  Aborting."; exit 1; }
done

# Depending on the OS, figure out which driver package file to download
if [[ "$OSTYPE" == "linux-gnu" ]]; then
  #is it 32 or 64 bit linux...
  MACHINE_TYPE=`uname -m`
  if [ ${MACHINE_TYPE} == 'x86_64' ]; then
    # 64 Bit Linux
    FilesToDownload=( \
      $ChromeDriverBasePath"linux64.zip" \
      $GeckoDriverBasePath"linux64.tar.gz" \
    )
  else
    # 32 Bit Linux
    FilesToDownload=( \
      $ChromeDriverBasePath"linux32.zip" \
      $GeckoDriverBasePath"linux32.tar.gz" \
    )
  fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
  # Apple OSX / Macbook
  FilesToDownload=( \
    $ChromeDriverBasePath"mac64.zip" \
    $GeckoDriverBasePath"macos.tar.gz" \
  )
elif [[ "$OSTYPE" == "win32" ]]; then
  # Microsoft Windows
  FilesToDownload=( \
    $ChromeDriverBasePath"win32.zip" \
    $GeckoDriverBasePath"win32.zip" \
  )
else
  echo "ERROR: Unknown OS type"
  exit 1
fi

# make the path extension subfolder
mkdir -p $PathExt"/tmp"

# Download the driver package files
for download_url in ${FilesToDownload[*]}
do
  basename=${download_url##*/}
  file_path=$PathExt"/tmp/$basename"
  if [ ! -e $file_path ]
  then
    wget -x \
      -O $file_path \
      $download_url
  fi
done

# Extract package files
pushd $PathExt
shopt -s nullglob #need this for cases where no .tar.bz2 files
for p in tmp/*.zip; do unzip -n -q $p; done
for p in tmp/*.tar.bz2; do tar jxf $p; done
for p in tmp/*.tar.gz; do tar xzf $p; done
popd

echo "Setup successful"
