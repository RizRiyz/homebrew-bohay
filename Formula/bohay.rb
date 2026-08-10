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
  version "0.10.0"
  license "MIT"
  head "https://github.com/RizRiyz/bohay.git", branch: "main"

  # Deliberately no `depends_on "git"` / `"gh"`. bohay only *shells out* to them:
  # git powers the git tab + worktrees, gh adds GitHub PRs/issues, and the
  # multiplexer runs fine without either (`bohay doctor` reports what's missing).
  # Declaring them would drag Homebrew's own git onto machines that already have
  # the system one, which defeats the point of a 3 MB binary install.

  on_macos do
    on_arm do
      url "https://github.com/RizRiyz/bohay/releases/download/v0.10.0/bohay-v0.10.0-aarch64-apple-darwin.tar.gz"
      sha256 "d85afda6484c3c04d437e627f99a0c8fa17bd74bbc001c547571e06b0fd02a3f"
    end
    on_intel do
      url "https://github.com/RizRiyz/bohay/releases/download/v0.10.0/bohay-v0.10.0-x86_64-apple-darwin.tar.gz"
      sha256 "c3d7f9037a380380dfe65d2df02524603ea613f52acad5aeeb4fcd3239611724"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/RizRiyz/bohay/releases/download/v0.10.0/bohay-v0.10.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "95f166681ce644694fed1ee4e10aed99070389c5eee71eca56bc3daa83368ebc"
    end
    on_arm do
      url "https://github.com/RizRiyz/bohay/releases/download/v0.10.0/bohay-v0.10.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "455c168626d8036e85b379e92e6a602c6b3a2080d7d647a5bb2639a66d26d6ca"
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
