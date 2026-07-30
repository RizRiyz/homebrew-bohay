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
  version "0.9.6"
  license "MIT"
  head "https://github.com/RizRiyz/bohay.git", branch: "main"

  # Deliberately no `depends_on "git"` / `"gh"`. bohay only *shells out* to them:
  # git powers the git tab + worktrees, gh adds GitHub PRs/issues, and the
  # multiplexer runs fine without either (`bohay doctor` reports what's missing).
  # Declaring them would drag Homebrew's own git onto machines that already have
  # the system one, which defeats the point of a 3 MB binary install.

  on_macos do
    on_arm do
      url "https://github.com/RizRiyz/bohay/releases/download/v0.9.6/bohay-v0.9.6-aarch64-apple-darwin.tar.gz"
      sha256 "805b3822dd390ec2eb28193b815b10352bbd064e6c627c65292facd08d66b24b"
    end
    on_intel do
      url "https://github.com/RizRiyz/bohay/releases/download/v0.9.6/bohay-v0.9.6-x86_64-apple-darwin.tar.gz"
      sha256 "606ea136b2ae688da556ec7dbfd106f47945c8041963e8512852a12e3ee985d6"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/RizRiyz/bohay/releases/download/v0.9.6/bohay-v0.9.6-x86_64-unknown-linux-musl.tar.gz"
      sha256 "e07b19bb1044bbd9461c7ca60d0cd2389360e82b0e5963ec19b03903ee3040a9"
    end
    on_arm do
      url "https://github.com/RizRiyz/bohay/releases/download/v0.9.6/bohay-v0.9.6-aarch64-unknown-linux-musl.tar.gz"
      sha256 "063bf69e69e0cbc0c43249608eb5a7215c95d2e1e9d3d0d58fb5a8ca665ff65e"
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
