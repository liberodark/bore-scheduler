{
  lib,
  fetchFromGitHub,
  linuxPackages_6_6,
  linuxPackages_6_12,
  ...
}:

let
  version = "5.9.6";

  bore-scheduler = fetchFromGitHub {
    owner = "firelzrd";
    repo = "bore-scheduler";
    rev = "488257315b37df8f6ca39e77fffeca39be4c0caa";
    hash = "sha256-FTg+IoO+3I3OyPsOaOFfVO6/tHOHWcyVKtJplVSEORk=";
  };

  # Function to get patches based on kernel version
  getPatchesForKernel = kernelVersion: [
    {
      name = "bore-scheduler";
      patch = "${bore-scheduler}/patches/stable/linux-${kernelVersion}-bore/0001-linux${kernelVersion}.y-bore${version}.patch";
    }
    {
      name = "bore-scheduler-ext-fix";
      patch = "${bore-scheduler}/patches/additions/0002-sched-ext-coexistence-fix.patch";
    }
  ];

  # Function to create kernel package for specific version
  makeKernelPackage =
    kernelPkg: kernelVersion:
    let
      kernel = kernelPkg.kernel.override {
        structuredExtraConfig = with lib.kernel; {
          SCHED_BORE = yes;
        };

        kernelPatches = getPatchesForKernel kernelVersion;

        extraMeta = {
          branch = kernelVersion;
          maintainers = with lib.maintainers; [ liberodark ];
          description = "Linux kernel with BORE (Burst-Oriented Response Enhancer) CPU scheduler ${version}";
        };
      };
    in
    kernelPkg.extend (_self: _super: {
      inherit kernel;
    });

in
{
  linuxPackages_6_6_bore = makeKernelPackage linuxPackages_6_6 "6.6";
  linuxPackages_6_12_bore = makeKernelPackage linuxPackages_6_12 "6.12";
}
