{ pkgs, ... }:
with pkgs.python3Packages;
let
  aiocmd = buildPythonPackage rec {
    pname = "aiocmd";
    version = "0.1.5";
    propagatedBuildInputs = [ prompt-toolkit ];
    src = fetchPypi {
      inherit pname version;
      hash = "sha256-rCz3+N+NpFRi9qD4bpQ6RCeZdSnVvs98IOotODXwTOA=";
    };
  };
  psutil = buildPythonPackage rec {
    pname = "psutil";
    version = "6.1.0";
    src = fetchPypi {
      inherit pname version;
      hash = "sha256-NTgV9Zp/ZM2socAwfuE1WKBRL22wZOkv6DN4TwhTnHo=";
    };
  };
in buildPythonPackage rec {
  pname = "openfreebuds";
  version = "0.17.0";
  format = "pyproject";
  nativeBuildInputs = [ pdm-backend ];
  propagatedBuildInputs = [ aiocmd aiohttp packaging pillow psutil qasync pynput dbus-next ];
  src = pkgs.fetchFromGitHub {
    owner = "melianmiko";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-1NfcF1MoBXb+PPNJx993fzQNcGOZAZwf9QxzTvZcbxw=";
  };
}
