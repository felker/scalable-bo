FROM continuumio/miniconda3

WORKDIR /scalable-bo

RUN apt-get update
RUN apt-get install vim -y

# Copy the repo
COPY . .

# Move to build
WORKDIR /scalable-bo/build

# Create new conda environment
RUN conda update -n base -c defaults conda -y 
RUN conda create -n dhenv python=3.8 -y --quiet

# Make RUN commands use the new environment:
SHELL ["conda", "run", "-n", "dhenv", "/bin/bash", "-c"]

# Install OpenMPI
RUN conda install -c conda-forge openmpi mpi4py=3.1.3 -y
RUN echo "export OMPI_ALLOW_RUN_AS_ROOT=1" >> ~/.bashrc
RUN echo "export OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1" >> ~/.bashrc

# Clone & Install DeepHyper/Scikit-Optimize (develop)
RUN git clone https://github.com/deephyper/scikit-optimize.git deephyper-scikit-optimize
RUN cd deephyper-scikit-optimize/ && git checkout 4cdc150f74bb066d07a7e57986ceeaa336204e26 && cd ..
RUN pip install -e deephyper-scikit-optimize/

# Clone & Install DeepHyper (develop)
RUN git clone https://github.com/deephyper/deephyper.git
RUN cd deephyper/ && git checkout 7a2d553227bc62aa5ba7a307375cf729fc6178ca && cd ..
RUN pip install -e deephyper/

# Install Scalable-BO
RUN pip install -e ../src/scalbo/

# activate 'dh' environment by default
RUN echo "conda activate dhenv" >> ~/.bashrc

WORKDIR /scalable-bo