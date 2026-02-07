{pkgs, ...}: {
  users.users.sean = {
    isNormalUser = true;
    initialPassword = "1";
    #hashedPasswordFile = "/persist/passwords/sean";
    description = "sean";
    extraGroups = ["networkmanager" "wheel" "libvirtd" "kvm"];
    packages = with pkgs; [];
    shell = pkgs.nushell;
  };
}
