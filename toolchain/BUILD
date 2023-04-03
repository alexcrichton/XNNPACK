package(default_visibility = ['//visibility:public'])

load(":cc_toolchain_config.bzl", "cc_toolchain_config")

cc_toolchain_suite(
    name = "wasi",
    toolchains = {
      "wasm": ":wasi_toolchain",
      #"wasm|emscripten": ":wasm_toolchain",
    },
)

filegroup(name = "empty")

cc_toolchain(
    name = "wasi_toolchain",
    toolchain_identifier = "wasi-toolchain",
    toolchain_config = ":wasi_config",
    all_files = ":empty",
    compiler_files = ":empty",
    dwp_files = ":empty",
    linker_files = ":empty",
    objcopy_files = ":empty",
    strip_files = ":empty",
    supports_param_files = 0,
)

cc_toolchain_config(name = "wasi_config")

