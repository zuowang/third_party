# Makefile for yaml-cpp-0.5.1. Why use cmake?
# NOTE: requires two parameters: 1) BOOST_PREFIX, 2) TARGET
# Author: Xun Zheng (xunzheng@cs.cmu.edu)

CXX = g++
CXXFLAGS = -O2 -Wextra
INCFLAGS = -I ./include -I $(BOOST_PREFIX)/include

SRC = $(shell find src/ -type f -name *.cpp)
OBJ = $(SRC:.cpp=.cpp.o)
THIRD_PARTY_LIB = /root/mxnet/third_party/lib

all: $(TARGET) $(THIRD_PARTY_LIB)/libyaml-cpp.so
$(TARGET): $(OBJ)
	ar csrv $@ $^

$(THIRD_PARTY_LIB)/libyaml-cpp.so: $(OBJ)
	g++ -g -o0 -std=c++11 -shared -o $@ $(OBJ) -fPIC 

$(OBJ): %.cpp.o: %.cpp
	$(CXX) $(CXXFLAGS) $(INCFLAGS) -c $< -o $@ -fPIC

clean:
	rm -f $(OBJ) $(TARGET)
