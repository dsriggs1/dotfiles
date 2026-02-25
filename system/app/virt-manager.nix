{lib, ...}: {
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  virtualisation.vmVariant = {
    users.users.sean = {
      hashedPasswordFile = lib.mkForce null;
      initialPassword = "test";
    };
    virtualisation.diskSize = 20480;
    virtualisation.memorySize = 4096;
    virtualisation.cores = 4;
    virtualisation.qemu.options = ["-cpu" "host"];
  };
}
