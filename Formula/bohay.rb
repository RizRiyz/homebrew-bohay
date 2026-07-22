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
  version "0.8.1"
  license "MIT"
  head "https://github.com/RizRiyz/bohay.git", branch: "main"

  # Deliberately no `depends_on "git"` / `"gh"`. bohay only *shells out* to them:
  # git powers the git tab + worktrees, gh adds GitHub PRs/issues, and the
  # multiplexer runs fine without either (`bohay doctor` reports what's missing).
  # Declaring them would drag Homebrew's own git onto machines that already have
  # the system one, which defeats the point of a 3 MB binary install.

  on_macos do
    on_arm do
      url "https://github.com/RizRiyz/bohay/releases/download/v0.8.1/bohay-v0.8.1-aarch64-apple-darwin.tar.gz"
      sha256 "db213be1adf60f5e1db1b7b111cf6c580d57a2acd7e44f7ebe435108bfbd80cc"
    end
    on_intel do
      url "https://github.com/RizRiyz/bohay/releases/download/v0.8.1/bohay-v0.8.1-x86_64-apple-darwin.tar.gz"
      sha256 "65154fcec6b714a035a12e6017ff1c9663bbea0dc2499d4903da6e7c7c5def20"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/RizRiyz/bohay/releases/download/v0.8.1/bohay-v0.8.1-x86_64-unknown-linux-musl.tar.gz"
      sha256 "7756190af22e0a0419ac89cec45eba42fa0cb701c22458bae4109bfa823eb49f"
    end
    on_arm do
      url "https://github.com/RizRiyz/bohay/releases/download/v0.8.1/bohay-v0.8.1-aarch64-unknown-linux-musl.tar.gz"
      sha256 "ab58af21e6465bc239dadeacf648730c3e51449facab2e4019d9f9f6f2276dbc"
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
