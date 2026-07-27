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
  version "0.9.4"
  license "MIT"
  head "https://github.com/RizRiyz/bohay.git", branch: "main"

  # Deliberately no `depends_on "git"` / `"gh"`. bohay only *shells out* to them:
  # git powers the git tab + worktrees, gh adds GitHub PRs/issues, and the
  # multiplexer runs fine without either (`bohay doctor` reports what's missing).
  # Declaring them would drag Homebrew's own git onto machines that already have
  # the system one, which defeats the point of a 3 MB binary install.

  on_macos do
    on_arm do
      url "https://github.com/RizRiyz/bohay/releases/download/v0.9.4/bohay-v0.9.4-aarch64-apple-darwin.tar.gz"
      sha256 "8666a4c7d55602c7002c95b95c9d0017fc153976967f93236997d3cdb534829f"
    end
    on_intel do
      url "https://github.com/RizRiyz/bohay/releases/download/v0.9.4/bohay-v0.9.4-x86_64-apple-darwin.tar.gz"
      sha256 "42e8ee569ba34448b173e57db16fab47cb82cd9d3d451f9f45a6525d7499acd7"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/RizRiyz/bohay/releases/download/v0.9.4/bohay-v0.9.4-x86_64-unknown-linux-musl.tar.gz"
      sha256 "673de4c9027ed0e8ed58b6ac55a51e7d24dd309a5888b8e4d8febb34bb85a66d"
    end
    on_arm do
      url "https://github.com/RizRiyz/bohay/releases/download/v0.9.4/bohay-v0.9.4-aarch64-unknown-linux-musl.tar.gz"
      sha256 "a674ea6e2859f5fe36c9e68b352b4b650027c31104f6f7f3bb58f76e7fd23c22"
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
