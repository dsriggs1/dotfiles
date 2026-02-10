{...}: {
  # PAM configuration for KDE Wallet integration
  # This enables automatic kwallet unlock at login
  security.pam.services = {
    sddm.enableKwallet = true;
    kde.enableKwallet = true;
  };
}
