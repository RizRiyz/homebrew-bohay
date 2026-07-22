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
  version "0.8.2"
  license "MIT"
  head "https://github.com/RizRiyz/bohay.git", branch: "main"

  # Deliberately no `depends_on "git"` / `"gh"`. bohay only *shells out* to them:
  # git powers the git tab + worktrees, gh adds GitHub PRs/issues, and the
  # multiplexer runs fine without either (`bohay doctor` reports what's missing).
  # Declaring them would drag Homebrew's own git onto machines that already have
  # the system one, which defeats the point of a 3 MB binary install.

  on_macos do
    on_arm do
      url "https://github.com/RizRiyz/bohay/releases/download/v0.8.2/bohay-v0.8.2-aarch64-apple-darwin.tar.gz"
      sha256 "45d09e5080254aae1c2cde7b775bfe2916af3b47439914da5f2b56dd335d39bd"
    end
    on_intel do
      url "https://github.com/RizRiyz/bohay/releases/download/v0.8.2/bohay-v0.8.2-x86_64-apple-darwin.tar.gz"
      sha256 "5a7ccda66f0d16223990d8e82e41da73d8f72d4996298cdcc09769837a3f88b9"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/RizRiyz/bohay/releases/download/v0.8.2/bohay-v0.8.2-x86_64-unknown-linux-musl.tar.gz"
      sha256 "378d086da5bad8c956e1a80129206f50cbbe2ced74cd8beb1b34ab3958a9ece0"
    end
    on_arm do
      url "https://github.com/RizRiyz/bohay/releases/download/v0.8.2/bohay-v0.8.2-aarch64-unknown-linux-musl.tar.gz"
      sha256 "23086c2e3ecd68267d3775b9d418e113634fde8e7d41695fba58c916a6436668"
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
