# SPDX-FileCopyrightText:  2021 Richard Brežák and NixNG contributors
#
# SPDX-License-Identifier: MPL-2.0
#
#   This Source Code Form is subject to the terms of the Mozilla Public
#   License, v. 2.0. If a copy of the MPL was not distributed with this
#   file, You can obtain one at http://mozilla.org/MPL/2.0/.

final: prev:
let
  inherit (prev) haskellPackages callPackage;
  nixpkgsTrivialBuilders =
    final.callPackage "${prev.path}/pkgs/build-support/trivial-builders.nix" {
      runtimeShell = final.busybox + "/bin/sh";
    };
in
{
  tinyLinux = callPackage ./tiny-linux.nix { };
  runVmLinux = final.callPackage ./run-vm-linux.nix { };
  cronie = callPackage ./cronie.nix { };
  sigell = haskellPackages.callPackage ./sigell/cabal.nix { };
  util-linuxSystemdFree = prev.util-linux.override {
    systemdSupport = false;
    pamSupport = true;
  };

  inherit (callPackage ./trivial-builders.nix {})
    writeSubstitutedFile
    writeSubstitutedShellScript
    writeSubstitutedShellScriptBin;

  inherit
    (nixpkgsTrivialBuilders)
    writeShellScript
    writeShellScriptBin
    writeShellScriptApplication;
}
