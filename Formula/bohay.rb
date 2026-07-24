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
  version "0.9.2"
  license "MIT"
  head "https://github.com/RizRiyz/bohay.git", branch: "main"

  # Deliberately no `depends_on "git"` / `"gh"`. bohay only *shells out* to them:
  # git powers the git tab + worktrees, gh adds GitHub PRs/issues, and the
  # multiplexer runs fine without either (`bohay doctor` reports what's missing).
  # Declaring them would drag Homebrew's own git onto machines that already have
  # the system one, which defeats the point of a 3 MB binary install.

  on_macos do
    on_arm do
      url "https://github.com/RizRiyz/bohay/releases/download/v0.9.2/bohay-v0.9.2-aarch64-apple-darwin.tar.gz"
      sha256 "64240df71f3066f5a048f1e8f4ca8764928bda66ab5fc6d5743642cbb44bda3c"
    end
    on_intel do
      url "https://github.com/RizRiyz/bohay/releases/download/v0.9.2/bohay-v0.9.2-x86_64-apple-darwin.tar.gz"
      sha256 "e65876d148eeed9233eb9ea13cfb876a70c6b94e5ddf31705c52a0f76b217e79"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/RizRiyz/bohay/releases/download/v0.9.2/bohay-v0.9.2-x86_64-unknown-linux-musl.tar.gz"
      sha256 "eb1a5f61caaace1273fd231b21526bb98cd1dfef0f8250a62c6ba20c8e08933d"
    end
    on_arm do
      url "https://github.com/RizRiyz/bohay/releases/download/v0.9.2/bohay-v0.9.2-aarch64-unknown-linux-musl.tar.gz"
      sha256 "5171311238ff675c7adbdab0312b80ae0d88ec9f23ef8137e5ce7b183510960d"
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
