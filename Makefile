THIRD_PARTY := $(shell readlink $(dir $(lastword $(MAKEFILE_LIST))) -f)
THIRD_PARTY_CENTRAL = $(THIRD_PARTY)/central
THIRD_PARTY_SRC = $(THIRD_PARTY)/src
THIRD_PARTY_INCLUDE = $(THIRD_PARTY)/include
THIRD_PARTY_LIB = $(THIRD_PARTY)/lib
THIRD_PARTY_BIN = $(THIRD_PARTY)/bin

all: third_party_all

third_party_minimal:    path \
                        fastapprox \
                        eigen \
                        libconfig \
                        cuckoo \
                        leveldb \
                        boost 


third_party_core: path \
	                gflags \
                  glog \
                  gperftools \
								  snappy \
                  sparsehash \
									fastapprox	\
									yaml-cpp \
									eigen \
									zeromq


third_party_all: third_party_core \
                  oprofile \
									boost \
                  libconfig \
									cuckoo \
									leveldb \
									float_compressor

distclean:
	rm -rf $(THIRD_PARTY_INCLUDE) $(THIRD_PARTY_LIB) $(THIRD_PARTY_BIN) \
		$(THIRD_PARTY_SRC) $(THIRD_PARTY)/share

.PHONY: third_party_core third_party_all distclean

path:
	mkdir -p $(THIRD_PARTY_LIB)
	mkdir -p $(THIRD_PARTY_INCLUDE)
	mkdir -p $(THIRD_PARTY_BIN)
	mkdir -p $(THIRD_PARTY_SRC)

# ==================== boost ====================

BOOST_SRC = $(THIRD_PARTY_CENTRAL)/boost_1_58_0.tar.bz2
BOOST_INCLUDE = $(THIRD_PARTY_INCLUDE)/boost

boost: path $(BOOST_INCLUDE)

$(BOOST_INCLUDE): $(BOOST_SRC)
	tar jxf $< -C $(THIRD_PARTY_SRC)
	cd $(basename $(basename $(THIRD_PARTY_SRC)/$(notdir $<))); \
	./bootstrap.sh --with-libraries=system,thread \
		--prefix=$(THIRD_PARTY); \
	./b2 install

# ===================== cuckoo =====================

CUCKOO_SRC = $(THIRD_PARTY_CENTRAL)/libcuckoo.tar
CUCKOO_INCLUDE = $(THIRD_PARTY_INCLUDE)/libcuckoo

cuckoo: path $(CUCKOO_SRC)
	tar xf $(CUCKOO_SRC) -C $(THIRD_PARTY_SRC); \
	cp -r $(THIRD_PARTY_SRC)/libcuckoo/libcuckoo $(THIRD_PARTY_INCLUDE)/

$(CUCKOO_INCLUDE): $(CUCKOO_SRC)
	tar xf $< -C $(THIRD_PARTY_SRC)
	cd $(basename $(basename $(THIRD_PARTY_SRC)/$(notdir $<))); \
	autoreconf -fis; \
	./configure --prefix=$(THIRD_PARTY); \
	make; make install

# ==================== eigen ====================

EIGEN_SRC = $(THIRD_PARTY_CENTRAL)/eigen-3.2.4.tar.bz2
EIGEN_INCLUDE = $(THIRD_PARTY_INCLUDE)/Eigen

eigen: path $(EIGEN_INCLUDE)

$(EIGEN_INCLUDE): $(EIGEN_SRC)
	tar jxf $< -C $(THIRD_PARTY_SRC)
	cp -r $(THIRD_PARTY_SRC)/eigen-eigen-10219c95fe65/Eigen \
		$(THIRD_PARTY_INCLUDE)/

# ==================== fastapprox ===================

FASTAPPROX_SRC = $(THIRD_PARTY_CENTRAL)/fastapprox-0.3.2.tar.gz
FASTAPPROX_INC = $(THIRD_PARTY_INCLUDE)/fastapprox

fastapprox: path $(FASTAPPROX_INC)

$(FASTAPPROX_INC): $(FASTAPPROX_SRC)
	tar xzf $< -C $(THIRD_PARTY_SRC)
	mkdir $(THIRD_PARTY_INCLUDE)/fastapprox
	cp $(basename $(basename $(THIRD_PARTY_SRC)/$(notdir $<)))/src/*.h \
		$(THIRD_PARTY_INCLUDE)/fastapprox

# ==================== float_compressor ====================

FC_SRC = $(THIRD_PARTY_CENTRAL)/float16_compressor.hpp

float_compressor: path
	cp $(THIRD_PARTY_CENTRAL)/float16_compressor.hpp $(THIRD_PARTY_INCLUDE)/

# ===================== gflags ===================

GFLAGS_SRC = $(THIRD_PARTY_CENTRAL)/gflags-2.0.tar.gz
GFLAGS_LIB = $(THIRD_PARTY_LIB)/libgflags.so

gflags: path $(GFLAGS_LIB)

$(GFLAGS_LIB): $(GFLAGS_SRC)
	tar zxf $< -C $(THIRD_PARTY_SRC)
	cd $(basename $(basename $(THIRD_PARTY_SRC)/$(notdir $<))); \
	./configure --prefix=$(THIRD_PARTY); \
	make install

# ===================== glog =====================

GLOG_SRC = $(THIRD_PARTY_CENTRAL)/glog-0.3.3.tar.gz
GLOG_LIB = $(THIRD_PARTY_LIB)/libglog.so

glog: $(GLOG_LIB)

$(GLOG_LIB): $(GLOG_SRC)
	tar zxf $< -C $(THIRD_PARTY_SRC)
	cd $(basename $(basename $(THIRD_PARTY_SRC)/$(notdir $<))); \
	./configure --prefix=$(THIRD_PARTY); \
	make install

# ================== gperftools =================

GPERFTOOLS_SRC = $(THIRD_PARTY_CENTRAL)/gperftools-2.4.tar.gz
GPERFTOOLS_LIB = $(THIRD_PARTY_LIB)/libtcmalloc.so

gperftools: path $(GPERFTOOLS_LIB)

$(GPERFTOOLS_LIB): $(GPERFTOOLS_SRC)
	tar zxf $< -C $(THIRD_PARTY_SRC)
	cd $(basename $(basename $(THIRD_PARTY_SRC)/$(notdir $<))); \
	./configure --prefix=$(THIRD_PARTY) --enable-frame-pointers; \
	make install

# ==================== leveldb ===================

LEVELDB_SRC = $(THIRD_PARTY_CENTRAL)/leveldb-1.18.tar.gz
LEVELDB_LIB = $(THIRD_PARTY_LIB)/libleveldb.so

leveldb: path $(LEVELDB_LIB)

$(LEVELDB_LIB): $(LEVELDB_SRC)
	tar zxf $< -C $(THIRD_PARTY_SRC)
	cd $(basename $(basename $(THIRD_PARTY_SRC)/$(notdir $<))); \
	LIBRARY_PATH=$(THIRD_PARTY_LIB):${LIBRARY_PATH} \
	make; \
	cp ./libleveldb.* $(THIRD_PARTY_LIB)/; \
	cp -r include/* $(THIRD_PARTY_INCLUDE)/

# ==================== libconfig ===================

LIBCONFIG_SRC = $(THIRD_PARTY_CENTRAL)/libconfig-1.4.9.tar.gz
LIBCONFIG_LIB = $(THIRD_PARTY_LIB)/libconfig++.so

libconfig: path $(LIBCONFIG_LIB)

$(LIBCONFIG_LIB): $(LIBCONFIG_SRC)
	tar zxf $< -C $(THIRD_PARTY_SRC)
	cd $(basename $(basename $(THIRD_PARTY_SRC)/$(notdir $<))); \
	./configure --prefix=$(THIRD_PARTY) --enable-frame-pointers; \
	make install

# ==================== yaml-cpp ===================

YAMLCPP_SRC = $(THIRD_PARTY_CENTRAL)/yaml-cpp-0.5.1.tar.gz
YAMLCPP_MK = $(THIRD_PARTY_CENTRAL)/yaml-cpp.mk
YAMLCPP_LIB = $(THIRD_PARTY_LIB)/libyaml-cpp.a

yaml-cpp: boost $(YAMLCPP_LIB)

$(YAMLCPP_LIB): $(YAMLCPP_SRC)
	tar zxf $< -C $(THIRD_PARTY_SRC)
	cd $(basename $(basename $(THIRD_PARTY_SRC)/$(notdir $<))); \
	make -f $(YAMLCPP_MK) CFLAGS=-fPIC BOOST_PREFIX=$(THIRD_PARTY) TARGET=$@; \
	cp -r include/* $(THIRD_PARTY_INCLUDE)/

# =================== oprofile ===================
# NOTE: need libpopt-dev binutils-dev

OPROFILE_SRC = $(THIRD_PARTY_CENTRAL)/oprofile-1.0.0.tar.gz
OPROFILE_LIB = $(THIRD_PARTY_LIB)/libprofiler.so

oprofile: path $(OPROFILE_LIB)

$(OPROFILE_LIB): $(OPROFILE_SRC)
	tar zxf $< -C $(THIRD_PARTY_SRC)
	cd $(basename $(basename $(THIRD_PARTY_SRC)/$(notdir $<))); \
	./configure --prefix=$(THIRD_PARTY); \
	make install

# ================== sparsehash ==================

SPARSEHASH_SRC = $(THIRD_PARTY_CENTRAL)/sparsehash-2.0.2.tar.gz
SPARSEHASH_INCLUDE = $(THIRD_PARTY_INCLUDE)/sparsehash

sparsehash: path $(SPARSEHASH_INCLUDE)

$(SPARSEHASH_INCLUDE): $(SPARSEHASH_SRC)
	tar zxf $< -C $(THIRD_PARTY_SRC)
	cd $(basename $(basename $(THIRD_PARTY_SRC)/$(notdir $<))); \
	./configure --prefix=$(THIRD_PARTY); \
	make install

# ==================== snappy ===================

SNAPPY_SRC = $(THIRD_PARTY_CENTRAL)/snappy-1.1.2.tar.gz
SNAPPY_LIB = $(THIRD_PARTY_LIB)/libsnappy.so

snappy: path $(SNAPPY_LIB)

$(SNAPPY_LIB): $(SNAPPY_SRC)
	tar zxf $< -C $(THIRD_PARTY_SRC)
	cd $(basename $(basename $(THIRD_PARTY_SRC)/$(notdir $<))); \
	./configure --prefix=$(THIRD_PARTY); \
	make install

# ==================== zeromq ====================

ZMQ_SRC = $(THIRD_PARTY_CENTRAL)/zeromq-4.1.4.tar.gz
ZMQ_LIB = $(THIRD_PARTY_LIB)/libzmq.so

zeromq: path $(ZMQ_LIB)

$(ZMQ_LIB): $(ZMQ_SRC)
	tar zxf $< -C $(THIRD_PARTY_SRC)
	cd $(basename $(basename $(THIRD_PARTY_SRC)/$(notdir $<))); \
	export CFLAGS=-fPIC; \
        ./configure --prefix=$(THIRD_PARTY) --with-libsodium=no --with-libgssapi_krb5=no; \
	make install
	cp $(THIRD_PARTY_CENTRAL)/zmq.hpp $(THIRD_PARTY_INCLUDE)

