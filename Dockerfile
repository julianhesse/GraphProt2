FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04
COPY . /method
COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
SHELL [ "/bin/bash", "--login", "-c" ]
# RUN 'BASH_ENV=/etc/profile exec bash'
ENV PATH=/usr/local/cuda/bin:$PATH
ENV CPATH=/usr/local/cuda/include:$CPATH
ENV LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH
ENV DYLD_LIBRARY_PATH=/usr/local/cuda/lib:$DYLD_LIBRARY_PATH

RUN nvcc --version

# install miniconda
ENV CONDA_DIR $HOME/miniconda3
RUN chmod +x /method/Miniconda3-py37_4.9.2-Linux-x86_64.sh
RUN /method/Miniconda3-py37_4.9.2-Linux-x86_64.sh -b -p $CONDA_DIR
ENV PATH=$CONDA_DIR/bin:$PATH
RUN chmod +x $CONDA_DIR/etc/profile.d/conda.sh
RUN echo ". $CONDA_DIR/etc/profile.d/conda.sh" >> ~/.profile
RUN conda --version
RUN conda init bash

RUN conda update -n base -c defaults conda

# set up gp2env environment
ENV ENV_PREFIX gp2env
RUN conda create -n gp2env python=3.7
RUN conda clean --all --yes


      #conda install pytorch=1.2.0=py3.7_cuda10.0.130_cudnn7.6.2_0 torchvision=0.4.0=py37_cu100 cudatoolkit=10.0 -c pytorch &&\
RUN conda activate gp2env &&\
      pip install torch==1.2.0 &&\
      pip install torchvision==0.4.0 &&\
      conda install cudatoolkit=10.0 -c pytorch &&\
      pip install torch-scatter==1.3.1 -f https://pytorch-geometric.com/whl/torch-1.5.0.html &&\
      pip install torch-sparse==0.4.0 -f https://pytorch-geometric.com/whl/torch-1.5.0.html &&\
      pip install torch-cluster==1.4.4 -f https://pytorch-geometric.com/whl/torch-1.5.0.html &&\
      pip install torch-spline-conv==1.1.0 -f https://pytorch-geometric.com/whl/torch-1.5.0.html &&\
      pip install torch-geometric==1.3.1
      

# check install
RUN conda activate gp2env &&\
      python -c "import torch; print(torch.__version__)" &&\
      python -c "import torch; print(torch.cuda.is_available())" &&\
      python -c "import torch; print(torch.version.cuda)"

# additional tools
RUN conda activate gp2env &&\
      conda install -c bioconda bedtools &&\
      conda install -c bioconda ucsc-twobitinfo &&\
      conda install -c bioconda ucsc-twobittofa &&\
      conda install -c bioconda ucsc-bigwigaverageoverbed

RUN conda activate gp2env &&\
      python -m pip install /method --ignore-installed --no-deps -vv

RUN conda activate gp2env &&\
      conda install seaborn==0.10.1 &&\
      conda install -c bioconda viennarna=2.4.14 &&\
      pip install markdown==3.2.2 &&\
      pip install logomaker==0.8 &&\
      pip install ushuffle &&\
      pip install requests


# needed to activate environment before every command
ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]

# finished
RUN echo "Finished!!"
