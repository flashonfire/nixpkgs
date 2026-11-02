{
  lib,
  stdenv,
  buildPythonPackage,
  cmake,
  ninja,
  scikit-build-core,
  numpy,
  pillow,
  nanobind,
  libzxing-cpp,
  pytestCheckHook,
  libzint,
  python,
}:

buildPythonPackage {
  pname = "zxing-cpp";
  inherit (libzxing-cpp) src version;
  pyproject = true;

  sourceRoot = "${libzxing-cpp.src.name}/wrappers/python";

  dontUseCmakeConfigure = true;

  env = {
    nanobind_DIR = "${nanobind}/${python.sitePackages}/nanobind/cmake";
  };

  # Stub generation imports the freshly built module
  postPatch = lib.optionalString (stdenv.buildPlatform != stdenv.hostPlatform) ''
    sed -i -e '/^nanobind_add_stub(/,/^)/d' -e '/zxingcpp\.pyi$/d' CMakeLists.txt
  '';

  cmakeFlags = [
    (lib.cmakeBool "ZXING_USE_BUNDLED_ZINT" false)
    (lib.cmakeFeature "Python_INCLUDE_DIR" "${python}/include/${python.libPrefix}")
  ];

  build-system = [
    scikit-build-core
    nanobind
  ];

  dependencies = [ numpy ];

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    libzint
  ];

  nativeCheckInputs = [
    pillow
    pytestCheckHook
  ];

  enabledTestPaths = [ "test.py" ];

  pythonImportsCheck = [ "zxingcpp" ];

  meta = {
    inherit (libzxing-cpp.meta)
      homepage
      changelog
      description
      longDescription
      license
      maintainers
      platforms
      ;
  };
}
