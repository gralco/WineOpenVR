# Change to the path of your Wine libraries
WINEPATH_32=/opt/wine-staging/lib
WINEPATH_64=/opt/wine-staging/lib64

CFLAGS=-Isrc
CFLAGS_32=-m32
CFLAGS_64=
CXXFLAGS=$(CFLAGS)
CXXFLAGS_32=$(CFLAGS_32)
CXXFLAGS_64=$(CFLAGS_64)

LDFLAGS=-shared -lopenvr_api -lvulkan
LDFLAGS_32=-Lopenvr/bin/linux32 -L$(WINEPATH_32) -L$(WINEPATH_32)/wine -m32 $(LDFLAGS)
LDFLAGS_64=-Lopenvr/bin/linux64 -L$(WINEPATH_64) -L$(WINEPATH_64)/wine $(LDFLAGS)

C_SOURCES = vkel.c
CXX_SOURCES= \
	wovr_exports.cpp \
	d3dproxy.cpp \
	ivrsystem.cpp \
	ivrapplications.cpp \
	ivrsettings.cpp \
	ivrchaperone.cpp \
	ivrchaperonesetup.cpp \
	ivrcompositor.cpp \
	ivrnotifications.cpp \
	ivroverlay.cpp \
	ivrrendermodels.cpp \
	ivrextendeddisplay.cpp \
	ivrtrackedcamera.cpp \
	ivrscreenshots.cpp \
	ivrresources.cpp

CC=winegcc
CXX=wineg++

DLL_32=bin32/openvr_api.dll.so
DLL_64=bin64/openvr_api.dll.so
SPECFILE=src/openvr_api.spec

###############################################################################

C_OBJECTS_32=$(C_SOURCES:%.c=bin32/%.o)
C_OBJECTS_64=$(C_SOURCES:%.c=bin64/%.o)
CXX_OBJECTS_32=$(CXX_SOURCES:%.cpp=bin32/%.o)
CXX_OBJECTS_64=$(CXX_SOURCES:%.cpp=bin64/%.o)
OBJECTS_32=$(C_OBJECTS_32) $(CXX_OBJECTS_32)
OBJECTS_64=$(C_OBJECTS_64) $(CXX_OBJECTS_64)

all: $(DLL_32) $(DLL_64)

clean:
	rm -rf bin32 bin64

$(DLL_32): $(OBJECTS_32) $(SPECFILE)
	@mkdir -p bin32
	$(CXX) $(SPECFILE) -o $@ $(OBJECTS_32) $(LDFLAGS_32)

$(DLL_64): $(OBJECTS_64) $(SPECFILE)
	@mkdir -p bin64
	$(CXX) $(SPECFILE) -o $@ $(OBJECTS_64) $(LDFLAGS_64)

$(C_OBJECTS_32): bin32/%.o: src/%.c src/*.h
	@mkdir -p bin32
	$(CC) -c $(CFLAGS) $(CFLAGS_32) -o $@ $<

$(CXX_OBJECTS_32): bin32/%.o: src/%.cpp src/*.h
	@mkdir -p bin32
	$(CXX) -c $(CXXFLAGS) $(CXXFLAGS_32) -o $@ $<

$(C_OBJECTS_64): bin64/%.o: src/%.c src/*.h
	@mkdir -p bin64
	$(CC) -c $(CFLAGS) $(CFLAGS_64) -o $@ $<

$(CXX_OBJECTS_64): bin64/%.o: src/%.cpp src/*.h
	@mkdir -p bin64
	$(CXX) -c $(CXXFLAGS) $(CXXFLAGS_64) -o $@ $<
