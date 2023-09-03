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
pkg-config \
gcovr  \
cmake
 
RUN sudo mkdir -p /src/workspace

VOLUME /src/workspace

CMD cd /src/workspace && \
aarch64-none-elf-g++ --version && \
git clone --recurse-submodules https://github.com/lvgl/lv_drivers.git && \ 
cd lv_drivers && \
git checkout v8.3.0 && \
sudo chmod -R 777 . && \
sudo cp lv_drv_conf_template.h lv_drv_conf.h && \
sudo chmod 777 lv_drv_conf.h && \
sudo chmod -R 777 . && \
ls && \
cmake \
-DCMAKE_BUILD_TYPE=Release \
-DBUILD_SHARED_LIBS=OFF \
-DCMAKE_CXX_COMPILER=aarch64-none-elf-g++ \
-DCMAKE_C_COMPILER=aarch64-none-elf-gcc \
-DCMAKE_LINKER=aarch64-none-elf-ld \
-DCMAKE_EXE_LINKER_FLAGS="--specs=nosys.specs" \
-DCMAKE_INSTALL_PREFIX="cmake-build/lv_drivers-installation" -B./cmake-build && \
cd cmake-build && cmake --build . && cmake --install .  && \
cd lv_drivers-installation && \
zip --symlinks -r lv_drivers-v8.3.0-gcc-arm-10.3-2021.07-x86_64-aarch64-none-elf.zip . && \
exit
