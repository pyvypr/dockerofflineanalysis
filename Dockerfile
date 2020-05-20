# Docker file for creating a container for Jupyter with VyPR analysis
# Jupyter container on DockerHub is large in size and does not fulfill our purpose.
# See the link: https://hub.docker.com/r/jupyter/minimal-notebook
# Therefore, creating a layer on top of the default jupyter container is not feasible

# Date of creation - 26.03.2020
# Maintainer -  omjaved

# OS package, without tag means we will always take the latest os image
FROM ubuntu

# Exposing port 9000. A standard way to do it. We can also expose the port at build / run time.
EXPOSE 9000

# Current working directory to store repositories
WORKDIR vypranalysis/


# Installing necessary dependencies
RUN apt-get update && apt-get -y update              && \
    apt-get install -y build-essential python2.7 git && \
    apt-get -y install software-properties-common    && \
    apt-add-repository universe                      && \
    apt-get update                                   && \
    apt-get -y install python-pip                    && \
    pip install jupyter matplotlib flask requests         

# Fetching the GitHub code for OfflineAnalysisNotebook
RUN git clone http://www.github.com/martahan/OfflineAnalysisNotebooks.git 

# Set working directory to offlineanalysisnotebook to install all the dependencies
WORKDIR /vypranalysis/OfflineAnalysisNotebooks/

# Fetching the GitHub code for VyPR , Server and analysis
RUN git clone http://www.github.com/pyvypr/VyPRServer.git                                                             && \
    cd VyPRServer                                                                                                     && \
    git reset --hard c1e01e5a9b1428314e4af0911e0efacb02b41408                                                         && \
    cd ..                                                                                                             && \
    git clone http://www.github.com/pyvypr/VyPRAnalysis.git                                                           && \
    cd VyPRAnalysis                                                                                                   && \
    git reset --hard c1e01e5a9b1428314e4af0911e0efacb02b41408                                                         && \
    cd ..                                                                                                             && \
    git clone http://www.github.com/pyvypr/VyPR.git                                                                   && \
    cd VyPR                                                                                                           && \
    git reset --hard c1e01e5a9b1428314e4af0911e0efacb02b41408                                                         && \
    cd ..                                                                                                             && \
    git clone http://www.github.com/pyvypr/VyPR.git   /vypranalysis/OfflineAnalysisNotebooks/VyPRServer/VyPR/         && \
    cd VyPRServer/VyPR/                                                                                               && \
    git reset c1e01e5a9b1428314e4af0911e0efacb02b41408                                                                && \
    cd ../../                                                                                                         && \  
    cp verdicts.db /vypranalysis/OfflineAnalysisNotebooks/VyPRServer/verdicts.db                                      && \
    rm verdicts.db

# Start Jupyter Notebook
CMD ["jupyter", "notebook","--port=9000", "--ip=0.0.0.0", "--allow-root"]
