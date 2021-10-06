#!/bin/bash
set -x

apt-get update
apt-get -y install git rsync python3-sphinx
apt-get -y install python3-pip
pip3 install m2r2
pip3 install sphinx_rtd_theme

pwd ls -lah
export SOURCE_DATE_EPOCH=$(git log -1 --pretty=%ct)
 
##############
# BUILD DOCS #
##############
declare -i count=1;
declare childFolder='';
declare parentFolder='';
declare chldFolder='';
declare fileName='';
declare toctree='';
declare caption='';
declare filename='naming.txt';
declare rstFileNames="";
declare naming_content='';

#Path of the md file for category
dirs=(docs/**/*.md);

# copy Hyper link name for category
cp sphinx/$filename $filename
naming_content=$(cat $filename)

# get the max depth 
for dir in "${dirs[@]}"
do
  count=$count+1;
done

#build the toctree
for dir in "${dirs[@]}"
do
  # Get the folder, subfolder and file name
  parentFolder="$(cut -d'/' -f1 <<<"$dir")";
  chldFolder="$(cut -d'/' -f2 <<<"$dir")";
  file="$(cut -d'/' -f3 <<<"$dir")";
  fileName="$(cut -d'.' -f1 <<<"$file")";
  
  # creat the .rst file for the md file to link
  echo .. mdinclude:: ../$parentFolder/$chldFolder/$fileName.md > "sphinx/$fileName.rst" 
  
  
  if [[ (-z $childFolder) ]];
  then
    childFolder="$chldFolder";
	  rstFileNames="${fileName}"
	
  elif [[ $childFolder == $chldFolder ]];
  then
    rstFileNames="${rstFileNames}"$'\n'"   ${fileName}"
	
  elif [[ ($childFolder != $chldFolder) ]]; 
  then
    # get the caption for hyperlink from the name mapping file
    namingPairs=$(echo $naming_content | tr "," "\n")
    for pair in $namingPairs
    do
      echo "> [$pair]"
      docsName=$(cut -d'=' -f1 <<<"$pair")
      docsValue=$(cut -d'=' -f2 <<<"$pair")
      echo $docsName
      echo $docsValue
      if [ $docsName == $childFolder ]
      then
        caption=$docsValue;
        break
      fi
    done
	
	  # if no caption found in the mapping file default set to the folder name as caption name 
    if [[ (-z $caption) ]];
    then
      caption="$childFolder";
    fi
	
	  # Build one octree
    oneoctree=".. toctree::"$'\n'"   :maxdepth: $count"$'\n'"   :caption: $caption:"$'\n'"   "$'\n'"   $rstFileNames";
	
	  # attached to the parent toctree
	  toctree="${toctree}"$'\n'"${oneoctree}"$'\n'
	
    childFolder="$chldFolder";
    rstFileNames="${fileName}"
    caption=''
  fi
done

if [[ ($childFolder == $chldFolder) ]]; 
then
  # get the caption for hyperlink from the name mapping file
  namingPairs=$(echo $naming_content | tr "," "\n")
  for pair in $namingPairs
  do
    echo "> [$pair]"
    docsName=$(cut -d'=' -f1 <<<"$pair")
    docsValue=$(cut -d'=' -f2 <<<"$pair")
    echo $docsName
    echo $docsValue
    if [ $docsName == $childFolder ]
    then
      caption=$docsValue;
      break
    fi
  done

  #if no caption found in the mapping file default set to the folder name as caption name 
  if [[ (-z $caption) ]];
  then
    caption="$chldFolder";
  fi
  
  # Build one octree
  oneoctree=".. toctree::"$'\n'"   :maxdepth: $count"$'\n'"   :caption: $caption:"$'\n'"   "$'\n'"   $rstFileNames"
  
  # attached to the parent toctree
  toctree="${toctree}"$'\n'"${oneoctree}"
fi

# add the index.rst file dynamically
cd sphinx

# Add README
cat > index.rst <<EOC

Welcome to LLoyd's documentation!
=================================

${toctree}

Indices and tables
==================

* :ref:\`genindex\`
* :ref:\`modindex\`
* :ref:\`search\`
EOC

cat index.rst 
cd ..

# Python Sphinx, configured with sphinx/conf.py
# See https://www.sphinx-doc.org/
make clean
make html

#######################
# Update GitHub Pages #
#######################

git config --global user.name "${GITHUB_ACTOR}"
git config --global user.email "${GITHUB_ACTOR}@users.noreply.github.com"
 
docroot=`mktemp -d`
rsync -av "build/html/" "${docroot}/"
 
pushd "${docroot}"

git init
git remote add deploy "https://token:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git"
git checkout -b gh-pages
 
# Adds .nojekyll file to the root to signal to GitHub that  
# directories that start with an underscore (_) can remain
touch .nojekyll
 
# Add README
cat > README.md <<EOF
# README for the GitHub Pages Branch
This branch is simply a cache for the website served from 
EOF
 
# Copy the resulting html pages built from Sphinx to the gh-pages branch 
git add .
 
# Make a commit with changes and any new files
msg="Updating Docs for commit ${GITHUB_SHA} made on `date -d"@${SOURCE_DATE_EPOCH}" --iso-8601=seconds` from ${GITHUB_REF} by ${GITHUB_ACTOR}"
git commit -am "${msg}"
 
# overwrite the contents of the gh-pages branch on our github.com repo
git push deploy gh-pages --force
 
popd # return to main repo sandbox root
 
# exit cleanly
exit 0