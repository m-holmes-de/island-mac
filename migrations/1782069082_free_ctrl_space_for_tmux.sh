echo "macOS: free Ctrl+Space for tmux (disable 'Select the previous input source')"

# tmux's prefix is C-Space, but macOS binds Ctrl+Space to the input-source
# switcher (symbolic hotkey 60), so tmux never sees it. Disable hotkey 60.
# Ctrl+Opt+Space (hotkey 61) is left enabled so input-source switching still works.

PLIST="$HOME/Library/Preferences/com.apple.symbolichotkeys.plist"
PB=/usr/libexec/PlistBuddy

state=$("$PB" -c "Print :AppleSymbolicHotKeys:60:enabled" "$PLIST" 2>/dev/null || echo "missing")
if [[ "$state" == "true" ]]; then
  "$PB" -c "Set :AppleSymbolicHotKeys:60:enabled false" "$PLIST"
  echo "  Disabled Ctrl+Space input-source shortcut"
  # Reload symbolic hotkeys without a full logout (best effort).
  /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u 2>/dev/null || true
else
  echo "  Ctrl+Space shortcut already disabled (state: $state)"
fi
