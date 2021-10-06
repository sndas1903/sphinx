﻿# Sphinx Example for Documentation

A simple example using Sphinx to robert bosch realted project documentation.Normally Sphinx used reStructured Text(.rst) file to render the documentation . So if we have previously craeted .md file that we can include into .rst file to render in a automate way.

## Local Installation

    $ sudo apt-get install python-sphinx
    $ sudo pip install sphinx
    # Depends on which version you prefer ...
    $ sudo pip3 install sphinx

## local Quickstart (first time build project where spinx project folder was not set )

Sphinx offers an easy quickstart:

    $ mkdir docs
    $ cd docs
    # Quickstart, select yes for apidoc and mathjax and for splitting build and source.
    $ sphinx-quickstart
    $ sphinx

Choose to separate source and build directories, choose project name and version and the autodoc extension.



## create document locally 

    1) clone the repo code (gilt clone https://github.com/sndas1903/sphinx.git)
    2) Goto the project main folder (cd  C:\Users\sndas\Azure\Application\sphinx)
    3) if you want to include any .md file then add into docs folder and create .rst file and add reference in index.rst file in source folder 
       
       **example**
       continuous_integration.rst
       --------------------------------
       .. mdinclude:: ../docs/continuous_integration.md

       index.rst
       --------------------------------
       .. toctree::
          :maxdepth: 4
          :caption: Contents:

          home
          continuous_integration

    4) run **make html** (for html generation)


## use to install depency library when we tried to use any third party theme/ library supported by Shpinx

    1) Change theme  using any third party theme (https://github.com/search?utf8=%E2%9C%93&q=sphinx+theme)
       **example** 
       pip install sphinx_rtd_theme

       change conf.py 
       ---------------------------------
       import sphinx_rtd_theme
       html_theme = 'sphinx_rtd_theme'

    2) wanted generate the word document out of .md file then run below command and goto the build/singlehtml folder and check the docs file after successfully run below command.
        make singlehtml
        cd build/singlehtml/
        pandoc -o index.docx index.html

## create document through pipeline 

    1) clone the repo code (gilt clone https://github.com/sndas1903/sphinx.git)
    2) Add the .md file into  docs folder and create .rst file and add reference in index.rst file in source folder 
       
       **example**
       continuous_integration.rst
       --------------------------------
       .. mdinclude:: ../docs/continuous_integration.md

       index.rst
       --------------------------------
       .. toctree::
          :maxdepth: 4
          :caption: Contents:

          home
          continuous_integration
        
    3) commit and goto github action tab and check the artifact generated by recent pipeline run and download that it has all document file generated inside.