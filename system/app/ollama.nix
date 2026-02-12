{...}: {
  services.ollama = {
    enable = true;
    acceleration = "rocm"; # Use AMD Radeon 780M GPU acceleration
    # Ollama will be available at http://localhost:11434
  };

  # Open firewall for Ollama API (optional - only if you want remote access)
  # networking.firewall.allowedTCPPorts = [ 11434 ];
}
