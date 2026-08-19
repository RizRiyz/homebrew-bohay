# Homebrew cask for luvus-notch - the macOS notch/menu-bar companion for luvus.
#
# A cask points at a prebuilt .app (you can't build a GUI app from source in a
# cask). The `version` and `sha256` below are bumped automatically by the luvus
# release workflow on each `vX.Y.Z` tag.
#
# The app is ad-hoc signed but NOT notarized (no paid Apple Developer account),
# so Gatekeeper blocks it on first launch. Install with `--no-quarantine` to
# skip that, or run the command in the caveat below once.
#
#   brew install --cask --no-quarantine RizRiyz/luvus/luvus-notch
#
cask "luvus-notch" do
  version "0.11.0"
  sha256 "0000000000000000000000000000000000000000000000000000000000000000"

  # DMG is attached to the main luvus release (built from RizRiyz/luvus-notch).
  url "https://github.com/RizRiyz/luvus/releases/download/v#{version}/luvus-notch-#{version}.dmg",
      verified: "github.com/RizRiyz/luvus/"
  name "Luvus Notch"
  desc "Notch/menu-bar companion that shows Luvus agent status"
  homepage "https://github.com/RizRiyz/luvus-notch"

  # Also pull the luvus CLI it talks to (same tap).
  depends_on formula: "rizriyz/luvus/luvus"
  depends_on macos: ">= :sequoia"

  app "luvus-notch.app"

  caveats <<~EOS
    luvus-notch is ad-hoc signed but not notarized. If macOS says the app is
    "damaged" or from an "unidentified developer", clear the quarantine flag:

      xattr -dr com.apple.quarantine "#{appdir}/luvus-notch.app"

    (Or reinstall with `brew install --cask --no-quarantine luvus-notch`.)
  EOS

  # Clean up per-user state on `brew uninstall --zap`.
  zap trash: [
    "~/Library/Preferences/com.skyrizz.luvusnotch.plist",
    "~/Library/Caches/com.skyrizz.luvusnotch",
    "~/Library/HTTPStorages/com.skyrizz.luvusnotch",
    "~/Library/Application Scripts/com.skyrizz.luvusnotch",
    "~/Library/Containers/com.skyrizz.luvusnotch",
  ]
end
