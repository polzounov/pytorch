FROM arm32v7/python:3.7.15-buster

WORKDIR /app

# Important to use that fork (changed CMakeList.txt) and branch release/1.11
RUN git clone --recursive https://github.com/polzounov/pytorch && \
	cd pytorch && \
	git submodule sync && \
	git submodule update --init --recursive --jobs 0

RUN apt-get update
RUN apt-get install -y cmake libplib-dev
RUN pip install pyyaml typing-extensions

RUN cd pytorch/third_party/XNNPACK && git checkout 16d79edc423d0a622b190cbfc6703c39ca2c0097

RUN cd pytorch && \
	NO_CUDA=1 NO_DISTRIBUTED=1 NO_MKLDNN=1 BUILD_TEST=0 MAX_JOBS=8 \
	python setup.py bdist_wheel

# This will be the command to run the simulator
CMD ["/bin/bash"]


