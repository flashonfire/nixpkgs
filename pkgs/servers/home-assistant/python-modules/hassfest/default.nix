{
  buildPythonPackage,
  home-assistant,

  # build-system
  setuptools,

  # dependencies
  ruff,

  # tests
  pytestCheckHook,
}:

buildPythonPackage {
  pname = "hassfest";
  pyproject = true;

  inherit (home-assistant) version src;

  sourceRoot = "${home-assistant.src.name}/packages/hassfest";

  build-system = [ setuptools ];

  dependencies = [ ruff ];

  pythonImportsCheck = [ "hassfest" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = home-assistant.meta // {
    description = "Validate Home Asisstant integrations";
  };
}
