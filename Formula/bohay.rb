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
  version "0.8.3"
  license "MIT"
  head "https://github.com/RizRiyz/bohay.git", branch: "main"

  # Deliberately no `depends_on "git"` / `"gh"`. bohay only *shells out* to them:
  # git powers the git tab + worktrees, gh adds GitHub PRs/issues, and the
  # multiplexer runs fine without either (`bohay doctor` reports what's missing).
  # Declaring them would drag Homebrew's own git onto machines that already have
  # the system one, which defeats the point of a 3 MB binary install.

  on_macos do
    on_arm do
      url "https://github.com/RizRiyz/bohay/releases/download/v0.8.3/bohay-v0.8.3-aarch64-apple-darwin.tar.gz"
      sha256 "df100e520a23458ba4c1ac0f0327edc22fbb3a53d60b5e390311cd70051603eb"
    end
    on_intel do
      url "https://github.com/RizRiyz/bohay/releases/download/v0.8.3/bohay-v0.8.3-x86_64-apple-darwin.tar.gz"
      sha256 "5b8ba09c9aba488139b11c339e31c58847d2ccc52861316b29d9bf5d476c7e1b"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/RizRiyz/bohay/releases/download/v0.8.3/bohay-v0.8.3-x86_64-unknown-linux-musl.tar.gz"
      sha256 "65b626c15c1de6008f690fe546d3bcb65cf2d7fcc4ba55b9fcdce9fca3c9c15a"
    end
    on_arm do
      url "https://github.com/RizRiyz/bohay/releases/download/v0.8.3/bohay-v0.8.3-aarch64-unknown-linux-musl.tar.gz"
      sha256 "4dcdc431da3d9d03bc40b299167a0b283555a9986f23e26d29509605c73c7975"
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
