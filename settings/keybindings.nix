# Shared keybindings consumed by all window managers.
# Plasma uses these directly; qtile reads the generated JSON at runtime.
# Discrepancies default to plasma-manager values.
# WM-specific bindings (grow, normalize, scratchpads, etc.) stay in their
# respective configs and are NOT listed here.
{
  # --- Navigation ---
  focusLeft = "Meta+H";
  focusRight = "Meta+L";
  focusDown = "Meta+J";
  focusUp = "Meta+K";

  # --- Window ---
  windowClose = "Meta+Q"; # plasma default; was Meta+W in qtile
  windowFullscreen = "Meta+F";
  windowFloat = "Meta+T"; # from qtile; added to plasma as KrohnkiteToggleFloat

  # --- App launchers ---
  launchTerminal = "Meta+Return";
  launchBrowser = "Meta+Shift+B";
  launchFileManager = "Meta+E";
  launchVscode = "Meta+Shift+C";
  launchSystemMonitor = "Meta+Shift+Escape";
  appRunner = "Meta+Space"; # plasma default; qtile layout.next() on this key removed

  # --- Media ---
  volumeUp = "Meta+Up";
  volumeDown = "Meta+Down";
  volumeMute = "Meta+M";

  # --- Screenshots ---
  screenshotArea = "Meta+Shift+S";
  screenshotFull = "Print";
  screenshotWindow = "Meta+Print";

  # --- System ---
  powerMenu = "Meta+Ctrl+Delete";
  lockSession = "Meta+Ctrl+Alt+L";
}
