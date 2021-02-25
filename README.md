# WebAssembly Boilerplate

Develop a C++ program for both native :computer: and Web :earth_africa: simultaneously.

Portability, low level control and minimalism of the C language are great. The convenience, fast dev cycles, immediacy and global reach of Web publication are unmatched in other platforms. This repo is an attempt at combining the best of both worlds.

It relies on Emscripten tool chain for WASM compilation and Visual Studio build tools for native (MacOS support coming soon)

The only requirement is a Windows system with git. The rest is installed on demand if needed.

Emscripten, Visual studio build tools and Python are automatically installed locally in the directory if not found in the system.


### usage

First time setup. If you start with a clean machine without Visual Studio, Python or Emscripten installed it might take a bit to download and install aprox 4GB.

```sh
setup
```

To build and run:

```sh
build example\hello-world
run example\hello-world
```

### advance usage

You can build and run only `native` or `web`

```sh
build example\hello-world native
run example\hello-world native
```

```sh
build example\hello-world web
run example\hello-world web
```