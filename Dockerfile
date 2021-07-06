FROM ubuntu:16.04

#docker with programs and dependencies to run TE pipeline 

ENV PATH=/opt/anaconda/bin:${PATH} 

#dependencies
RUN apt-get update
RUN apt-get -y install python3-pip git wget zlib1g-dev perl gcc make libdbi-perl
RUN wget https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh
RUN chmod 700 ./Miniconda2-latest-Linux-x86_64.sh
RUN bash ./Miniconda2-latest-Linux-x86_64.sh -b -p /opt/anaconda/

RUN export PATH=/opt/anaconda/bin:${PATH}

#conda
RUN conda config --add channels defaults
RUN conda config --add channels conda-forge
RUN conda config --add channels bioconda

RUN conda install -c bioconda pysam==0.8.3 samtools

RUN pip install numpy cython
RUN pip install matplotlib matplotlib-venn
RUN pip install pybedtools psutil pandas memory_profiler


#RetroSeq 
RUN git clone https://github.com/kristinebilgrav/RetroSeq.git

#Jitterbug
RUN git clone https://github.com/elzbth/jitterbug.git

#Tiddit
RUN conda install tiddit

#MobileAnn
RUN git clone https://github.com/J35P312/MobileAnn.git

#SVDB
RUN pip install SVDB

