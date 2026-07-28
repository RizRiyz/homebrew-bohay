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
  desc "Mission control for your AI coding agents"
  homepage "https://github.com/RizRiyz/bohay"
  version "0.9.5"
  license "MIT"
  head "https://github.com/RizRiyz/bohay.git", branch: "main"

  # Deliberately no `depends_on "git"` / `"gh"`. bohay only *shells out* to them:
  # git powers the git tab + worktrees, gh adds GitHub PRs/issues, and the
  # multiplexer runs fine without either (`bohay doctor` reports what's missing).
  # Declaring them would drag Homebrew's own git onto machines that already have
  # the system one, which defeats the point of a 3 MB binary install.

  on_macos do
    on_arm do
      url "https://github.com/RizRiyz/bohay/releases/download/v0.9.5/bohay-v0.9.5-aarch64-apple-darwin.tar.gz"
      sha256 "de29ded83c81daa2b51e389c047bacf336722f29124011fcc2989f40a38eea9c"
    end
    on_intel do
      url "https://github.com/RizRiyz/bohay/releases/download/v0.9.5/bohay-v0.9.5-x86_64-apple-darwin.tar.gz"
      sha256 "c76855f708091441a2418f0a3f5537f3d8155cd1c3a513b58a81ae7a48321269"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/RizRiyz/bohay/releases/download/v0.9.5/bohay-v0.9.5-x86_64-unknown-linux-musl.tar.gz"
      sha256 "7ea4d2b529be07c08ee5eaddd5ae12662892f91e05283522c932539813b30be7"
    end
    on_arm do
      url "https://github.com/RizRiyz/bohay/releases/download/v0.9.5/bohay-v0.9.5-aarch64-unknown-linux-musl.tar.gz"
      sha256 "06119ac556e359e13f818680b4193236cfd59b85c0d30a752ec3c1690d17fa5c"
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
