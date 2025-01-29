# bore-scheduler

### Enable BORE
```
  boot.kernelPackages = pkgs.bore-scheduler.linuxPackages_6_12_bore;

  boot.kernel.sysctl = {
    "kernel.sched_bore" = 1;
  };

  nixpkgs.overlays = [
    (self: _super: {
      bore-scheduler = self.callPackage ./pkgs/bore-scheduler/package.nix {
        inherit (self) linuxPackages_6_6;
        inherit (self) linuxPackages_6_12;
      };
    })
  ];
```