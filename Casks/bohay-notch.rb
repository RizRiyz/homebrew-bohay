# Homebrew cask for bohay-notch - the macOS notch/menu-bar companion for bohay.
#
# A cask points at a prebuilt .app (you can't build a GUI app from source in a
# cask). The `version` and `sha256` below are bumped automatically by the bohay
# release workflow on each `vX.Y.Z` tag.
#
# The app is ad-hoc signed but NOT notarized (no paid Apple Developer account),
# so Gatekeeper blocks it on first launch. Install with `--no-quarantine` to
# skip that, or run the command in the caveat below once.
#
#   brew install --cask --no-quarantine RizRiyz/bohay/bohay-notch
#
cask "bohay-notch" do
  version "0.6.1"
  sha256 "27ff5e93663b6621192fa6465f18291c1e026f0fe37e42c1b9eb129b52427eb4"

  # DMG is attached to the main bohay release (built from RizRiyz/bohay-notch).
  url "https://github.com/RizRiyz/bohay/releases/download/v#{version}/bohay-notch-#{version}.dmg",
      verified: "github.com/RizRiyz/bohay/"
  name "bohay Notch"
  desc "Notch/menu-bar companion that shows bohay agent status"
  homepage "https://github.com/RizRiyz/bohay-notch"

  # Also pull the bohay CLI it talks to (same tap).
  depends_on formula: "rizriyz/bohay/bohay"
  depends_on macos: ">= :sequoia"

  app "bohay-notch.app"

  caveats <<~EOS
    bohay-notch is ad-hoc signed but not notarized. If macOS says the app is
    "damaged" or from an "unidentified developer", clear the quarantine flag:

      xattr -dr com.apple.quarantine "#{appdir}/bohay-notch.app"

    (Or reinstall with `brew install --cask --no-quarantine bohay-notch`.)
  EOS

  # Clean up per-user state on `brew uninstall --zap`.
  zap trash: [
    "~/Library/Preferences/com.skyrizz.bohaynotch.plist",
    "~/Library/Caches/com.skyrizz.bohaynotch",
    "~/Library/HTTPStorages/com.skyrizz.bohaynotch",
    "~/Library/Application Scripts/com.skyrizz.bohaynotch",
    "~/Library/Containers/com.skyrizz.bohaynotch",
  ]
end
