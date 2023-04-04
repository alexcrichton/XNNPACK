load("@bazel_tools//tools/build_defs/cc:action_names.bzl", "ACTION_NAMES")
load(
    "@bazel_tools//tools/cpp:cc_toolchain_config_lib.bzl",
    "feature",
    "flag_group",
    "flag_set",
    "tool_path",
)

all_link_actions = [
  ACTION_NAMES.cpp_link_executable,
  ACTION_NAMES.cpp_link_dynamic_library,
  ACTION_NAMES.cpp_link_nodeps_dynamic_library,
]

wasi_root = "/home/acrichto/code/wasi-sdk/build/install/opt/wasi-sdk"

def _impl(ctx):
    tool_paths = [
        tool_path(
            name = "gcc",
            path = wasi_root + "/bin/clang",
        ),
        tool_path(
            name = "ld",
            path = wasi_root + "/bin/wasm-ld",
        ),
        tool_path(
            name = "ar",
            path = wasi_root + "/bin/ar",
        ),
        tool_path(
            name = "cpp",
            path = "/bin/false",
        ),
        tool_path(
            name = "gcov",
            path = "/bin/false",
        ),
        tool_path(
            name = "nm",
            path = "/bin/false",
        ),
        tool_path(
            name = "objdump",
            path = "/bin/false",
        ),
        tool_path(
            name = "strip",
            path = "/bin/false",
        ),
    ]
    features = [
        feature(
            name = "default_clang_flags",
            enabled = True,
            flag_sets = [
                flag_set(
                    actions = [
                      ACTION_NAMES.c_compile,
                      ACTION_NAMES.cpp_compile,
                    ],
                    flag_groups = ([
                        flag_group(
                            flags = [
                                "-D_WASI_EMULATED_MMAN",
                                "-D_WASI_EMULATED_PROCESS_CLOCKS",
                                "-fno-exceptions",
                                "--target=wasm32-wasi-threads",
                                "-pthread",
                                "-matomics",
                                "-mbulk-memory",
                                "-O3",
                                "-DNDEBUG",
                            ]
                        ),
                    ]),
                ),
            ],
        ),
        feature(
            name = "default_linker_flags",
            enabled = True,
            flag_sets = [
                flag_set(
                    actions = all_link_actions,
                    flag_groups = ([
                        flag_group(
                            flags = [
                                "-lc++",
                                "-lc++abi",
                                "-lwasi-emulated-mman",
                                "-lwasi-emulated-process-clocks",
                                "-pthread",
                                "--target=wasm32-wasi-threads",
                                "-Wl,--import-memory,--export-memory",
                                "-Wl,-zstack-size=10485760",
                                "-Wl,--stack-first",
                                "-Wl,--max-memory=1073741824",
                            ],
                        ),
                    ]),
                ),
            ],
        ),
    ]

    return cc_common.create_cc_toolchain_config_info(
        ctx = ctx,
	cxx_builtin_include_directories = [wasi_root],
        features = features,
        toolchain_identifier = "wasi-toolchain",
        host_system_name = "local",
        target_system_name = "local",
        target_cpu = "wasm",
        target_libc = "unknown",
        compiler = "clang",
        abi_version = "unknown",
        abi_libc_version = "unknown",
        tool_paths = tool_paths,

    )

cc_toolchain_config = rule(
    implementation = _impl,
    attrs = {},
    provides = [CcToolchainConfigInfo],
)

