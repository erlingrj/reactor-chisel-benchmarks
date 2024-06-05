# Reactor-chisel benchmarks for TRETS publication
This repository contains the benchmarks from the TRETS publication "Codesign
of reactor-oriented hardware and software".

## Requirements
- verilator v4.222 or v5.006
- sbt v1.9.6
- python3
- Make
- CMake
- Vivado v2021.2 (Optional)
- oh-my-xilinx (Optional)
- fish shell (the automated scripts are based on fish)

## Getting started
Pull down sources:
```
git clone https://github.com/erlingrj/reactor-chisel-benchmarks --recursive && cd reactor-chisel-benchmarks
```

Compile a test program

```
lingua-franca/bin/lfc-dev src/SmokeTest.lf
bin/SmokeTest
```

## Latency test
The latency tests are simple reactor programs that are emulated using Verilator.
```
make latency
```

Results will be written to `results/latency`

## Throughput tests
The throughput tests are simple reactor programs that are emulated using Verilator.
```
make thru
```
Results will be written to `results/throughput`

## Resource utilization
To get the resource utilization of the reactor programs we need a synthesis toolchain. 
Reactor-chisel only supports Vivado and has only been tested with v2021.2

### Prerequisites
- Download and install Vivado. This is, unfortunately, a long and error-prone
undertaking and is beyond the scope of this guide. The vivado executable must
be on the system-path, verify with: `vivado --version`
- Clone oh-my-xilinx (https://github.com/ddanag/oh-my-xilinx) and point the environment variable OHMYXILINX to its directory. 

```
make resources
```

## Image Processing use case
### LF version

#### Emulation
To build and emulate the LF-based image processing app:
1. Update `src/img/ImageFilter.lf` such that the target property `cmake-include`
has the absolute path to `opencv.cmake`.
2. Compile with lfc
```
lingua-franca/bin/lfc-dev -c src/img/ImageFiltering.lf
```

3. Run verilator emulation
```
bin/ImageFiltering --rgbImgPath src/img/img.jpg
```
The resulting grayscale version is at `./gray.jpg`

#### Resource utilization
To calculate resource utilization with Vivado, we must change the
target fpgaBoard to ZedBoard in `src/img/ImageFiltering.lf` and then call:
```
./scripts/imgProc.fish
```

### fpga-tidbits version

#### Emulation
```
cd src/imgHandwritten
sbt run
cd build
make
./emu ../../img/img.jpg
```

The resulting grayscale image is at `./grayscale_output.jpg`

#### Resource utilization
```
./scripts/imgHand.fish
```