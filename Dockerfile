FROM armswdev/arm-tools:bare-metal-compilers

RUN sudo rm /var/lib/apt/lists/lock && \
sudo apt-get update -y && \
sudo apt-get upgrade -y && \
sudo apt-get -y --no-install-recommends install \
zip \
unzip \
gcc  \ 
python3  \
libpng-dev  \
ruby-full  \
gcovr  \
cmake
 
RUN sudo mkdir -p /src/workspace

VOLUME /src/workspace

CMD cd /src/workspace && \
aarch64-none-elf-g++ --version && \
git clone --recurse-submodules https://github.com/lvgl/lvgl.git && \ 
cd lvgl && \
git checkout v8.3.9 && \
cmake \
-DCMAKE_BUILD_TYPE=Release \
-DBUILD_SHARED_LIBS=OFF \
-DLV_CONF_BUILD_DISABLE_EXAMPLES=ON \
-DLV_CONF_BUILD_DISABLE_DEMOS=ON \
-DCMAKE_CXX_COMPILER=aarch64-none-elf-g++ \
-DCMAKE_C_COMPILER=aarch64-none-elf-gcc \
-DCMAKE_LINKER=aarch64-none-elf-ld \
-DCMAKE_EXE_LINKER_FLAGS="--specs=nosys.specs" \
-DCMAKE_INSTALL_PREFIX="cmake-build/lvgl-installation" -B./cmake-build && \
cd cmake-build && cmake --build . && cmake --install .  && \
cd lvgl-installation && \
zip --symlinks -r lvgl-v8.3.9-gcc-arm-10.3-2021.07-x86_64-aarch64-none-elf.zip . && \
exit
