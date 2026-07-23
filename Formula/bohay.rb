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
  version "0.9.1"
  license "MIT"
  head "https://github.com/RizRiyz/bohay.git", branch: "main"

  # Deliberately no `depends_on "git"` / `"gh"`. bohay only *shells out* to them:
  # git powers the git tab + worktrees, gh adds GitHub PRs/issues, and the
  # multiplexer runs fine without either (`bohay doctor` reports what's missing).
  # Declaring them would drag Homebrew's own git onto machines that already have
  # the system one, which defeats the point of a 3 MB binary install.

  on_macos do
    on_arm do
      url "https://github.com/RizRiyz/bohay/releases/download/v0.9.1/bohay-v0.9.1-aarch64-apple-darwin.tar.gz"
      sha256 "2ec555b6e4f8bf50fbf1ffa6524547529d574e966bf4039f1b32a378b91fd1b5"
    end
    on_intel do
      url "https://github.com/RizRiyz/bohay/releases/download/v0.9.1/bohay-v0.9.1-x86_64-apple-darwin.tar.gz"
      sha256 "98462ea5160dd66b388fac8e3301058203ea2082f2e31e8c619328c7e6bc27ed"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/RizRiyz/bohay/releases/download/v0.9.1/bohay-v0.9.1-x86_64-unknown-linux-musl.tar.gz"
      sha256 "9d4a7e3dc0f81422a18cca54b388bc933828bd0d27cc1b37dfbcfe38418ab54d"
    end
    on_arm do
      url "https://github.com/RizRiyz/bohay/releases/download/v0.9.1/bohay-v0.9.1-aarch64-unknown-linux-musl.tar.gz"
      sha256 "8a787ab92a7f37c2fdfa3f3a392929f5879defffddbf4a4b7899ec51ab3bb9b1"
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
