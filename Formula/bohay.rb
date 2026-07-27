# Homebrew formula for bohay.
#
# Installs the **prebuilt binary** from the GitHub release, so `brew install`
# is a ~3 MB download with no Rust toolchain and no compile step. Building the
# 100+ crate dependency graph from source peaks well over a gigabyte of RAM,
# which is exactly what people install a binary to avoid.
#
# Every platform we publish gets a prebuilt binary, Intel macs included (the
# release cross-compiles x86_64 on an Apple-silicon runner).
#
#   brew install RizRiyz/bohay/bohay
#   brew install --HEAD RizRiyz/bohay/bohay   # build the tip of main
#
# `scripts/release.sh` rewrites the version + every sha256 below from the
# release's published `.sha256` assets — don't hand-edit them.
class Bohay < Formula
  desc "Terminal multiplexer for AI coding agents"
  homepage "https://github.com/RizRiyz/bohay"
  version "0.9.3"
  license "MIT"
  head "https://github.com/RizRiyz/bohay.git", branch: "main"

  # Deliberately no `depends_on "git"` / `"gh"`. bohay only *shells out* to them:
  # git powers the git tab + worktrees, gh adds GitHub PRs/issues, and the
  # multiplexer runs fine without either (`bohay doctor` reports what's missing).
  # Declaring them would drag Homebrew's own git onto machines that already have
  # the system one, which defeats the point of a 3 MB binary install.

  on_macos do
    on_arm do
      url "https://github.com/RizRiyz/bohay/releases/download/v0.9.3/bohay-v0.9.3-aarch64-apple-darwin.tar.gz"
      sha256 "5f7f129ad7dcd874a299a8a4101a2000445879f355e1f1c9ba75f551a222a2c5"
    end
    on_intel do
      url "https://github.com/RizRiyz/bohay/releases/download/v0.9.3/bohay-v0.9.3-x86_64-apple-darwin.tar.gz"
      sha256 "3f71170673debd808b972179a80afe53435305ce5dad8ca43f9cf12e423448ec"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/RizRiyz/bohay/releases/download/v0.9.3/bohay-v0.9.3-x86_64-unknown-linux-musl.tar.gz"
      sha256 "db9869d1b705d8b0d19ac084298a85b87f4a55bf7916a03ab85fe7325e21af6c"
    end
    on_arm do
      url "https://github.com/RizRiyz/bohay/releases/download/v0.9.3/bohay-v0.9.3-aarch64-unknown-linux-musl.tar.gz"
      sha256 "fba2c38cf404b7437c3b2a40b1abb07d3eb6ca3be31fddc7ab7332bcc3a493f8"
    end
  end

  def install
    # `--HEAD` builds from a source checkout; every release path unpacks an
    # archive with the binary at its root.
    if build.head?
      system "cargo", "install", *std_cargo_args
    else
      bin.install "bohay"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bohay --version")
  end
end
