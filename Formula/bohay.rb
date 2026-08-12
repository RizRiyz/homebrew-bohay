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
  version "0.10.1"
  license "MIT"
  head "https://github.com/RizRiyz/bohay.git", branch: "main"

  # Deliberately no `depends_on "git"` / `"gh"`. bohay only *shells out* to them:
  # git powers the git tab + worktrees, gh adds GitHub PRs/issues, and the
  # multiplexer runs fine without either (`bohay doctor` reports what's missing).
  # Declaring them would drag Homebrew's own git onto machines that already have
  # the system one, which defeats the point of a 3 MB binary install.

  on_macos do
    on_arm do
      url "https://github.com/RizRiyz/bohay/releases/download/v0.10.1/bohay-v0.10.1-aarch64-apple-darwin.tar.gz"
      sha256 "80ed6ea8edb5f29652555aab4eb0c1e5b4a0017908d622756d81f30ac93c73ad"
    end
    on_intel do
      url "https://github.com/RizRiyz/bohay/releases/download/v0.10.1/bohay-v0.10.1-x86_64-apple-darwin.tar.gz"
      sha256 "c5911fd128773adf221243c0df803ef3fd77c924816dc9882ba5c1cac713a2b6"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/RizRiyz/bohay/releases/download/v0.10.1/bohay-v0.10.1-x86_64-unknown-linux-musl.tar.gz"
      sha256 "5e34985e2f7567fa191135d1b90ce91fa343b0cb890ae5ed38f2645cd261af08"
    end
    on_arm do
      url "https://github.com/RizRiyz/bohay/releases/download/v0.10.1/bohay-v0.10.1-aarch64-unknown-linux-musl.tar.gz"
      sha256 "ef21154a2a998d1003432667749d583122846a6ba947fbcd694534aae60aa7ee"
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
