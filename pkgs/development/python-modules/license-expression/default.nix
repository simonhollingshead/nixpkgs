{
  lib,
  boolean-py,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "license-expression";
  version = "30.4.3";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "aboutcode-org";
    repo = "license-expression";
    tag = "v${version}";
    hash = "sha256-e/pu2Mhy3E4ddGUGkVF7M9UFlB1IlXDPTReSh5gKwbE=";
  };

  dontConfigure = true;

  build-system = [ setuptools-scm ];

  dependencies = [ boolean-py ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "license_expression" ];

  meta = with lib; {
    description = "Utility library to parse, normalize and compare License expressions";
    homepage = "https://github.com/aboutcode-org/license-expression";
    changelog = "https://github.com/aboutcode-org/license-expression/blob/${src.tag}/CHANGELOG.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
