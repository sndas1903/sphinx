# Dockerfile for Sphinx-Needs
# Download base image of Ubuntu
FROM python:3



#TODO: fix and uncomment:  This is needed for local development under linux
# ARG USERNAME=dockeruser 
# ARG USER_ID=1000
# ARG GROUP_ID=$USER_ID
ARG version=pre-release

# To prevent interactive shells
ENV DEBIAN_FRONTEND=noninteractive

# Install apt & root utils needed inside devcontainer
RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  apt-get -y install --no-install-recommends apt-utils 2>&1 && \
  apt-get install -y software-properties-common && \
  apt-get install -qqy sudo

#TODO: fix and uncomment: This is needed for local development under linux
# Create dockeruser  
#   Create group if if does not exsits
#  RUN  $( getent group ${GROUP_ID} ) || groupadd -g ${GROUP_ID} ${USERNAME}  &&\
#     useradd -l -u ${USER_ID} -g ${USERNAME} ${USERNAME} &&\
#     install -d -m 0755 -o ${USERNAME} -g ${USERNAME} /home/${USERNAME} &&\
#     echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME &&\
#     chmod 0440 /etc/sudoers.d/$USERNAME &&\
#     chown -R dockeruser /home/dockeruser

# Upgrade as needed
RUN apt-get update && apt-get upgrade -y

# Install PIP
RUN apt-get -y install python3-pip

# Latex/PDF support for Sphinx-docs
RUN apt-get -y install \
  latexmk \
  texlive-fonts-recommended \
  texlive-lang-english \
  texlive-lang-french \
  texlive-lang-german \
  texlive-latex-extra \
  texlive-latex-recommended

# Install some basic tooling
RUN apt-get -y install \
  inotify-tools \
  wget

# Install PlantUML dependencies
RUN apt-get -y install \
  default-jre \
  graphviz

# Install PlantUML
RUN wget -c https://netcologne.dl.sourceforge.net/project/plantuml/plantuml.jar -O /tmp/plantuml.jar && \
    mkdir -p /usr/share/plantuml && \
    mv /tmp/plantuml.jar /usr/share/plantuml/plantuml.jar

# Install Doxygen
RUN apt-get -y install \
  doxygen

# Install Poetry
RUN curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python -

# Installation Sphinx-Needs
RUN \
    if [ "$version" = "pre-release" ]; then \
    git clone https://github.com/useblocks/sphinxcontrib-needs && cd sphinxcontrib-needs && pip3 install .; \
    else \
    pip3 install sphinxcontrib-needs; \
    fi

# Install PIP components
RUN pip3 install --upgrade \
  pip \
  sphinx \
  recommonmark \
  sphinx-rtd-theme \
  sphinxcontrib-plantuml \
  sphinx-test-reports==0.3.4 \
  sphinx-theme \
  breathe \
  rstcheck \
  exhale \
  myst_parser \
  sphinx-git \
  sphinx-copybutton

# Copy Sphinx-Needs VSCode Extension
ADD sphinxneeds-extn /home/dockeruser/.tools/sphinxneeds-extn 

WORKDIR /sphinxneeds

 # Start as dockeruser
 #TODO: fix and uncomment:  This is needed for local development under linux
 #USER dockeruser
 