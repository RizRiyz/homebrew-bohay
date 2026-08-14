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
  version "0.10.2"
  license "MIT"
  head "https://github.com/RizRiyz/bohay.git", branch: "main"

  # Deliberately no `depends_on "git"` / `"gh"`. bohay only *shells out* to them:
  # git powers the git tab + worktrees, gh adds GitHub PRs/issues, and the
  # multiplexer runs fine without either (`bohay doctor` reports what's missing).
  # Declaring them would drag Homebrew's own git onto machines that already have
  # the system one, which defeats the point of a 3 MB binary install.

  on_macos do
    on_arm do
      url "https://github.com/RizRiyz/bohay/releases/download/v0.10.2/bohay-v0.10.2-aarch64-apple-darwin.tar.gz"
      sha256 "020ae390832b661ff1684d361bfada1365afecae51a9c9293a70b5af6abb53c1"
    end
    on_intel do
      url "https://github.com/RizRiyz/bohay/releases/download/v0.10.2/bohay-v0.10.2-x86_64-apple-darwin.tar.gz"
      sha256 "edabf4db1b3fb33e1316ec3cacc7f30995fa601e121bbe1301603d1e3853d2be"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/RizRiyz/bohay/releases/download/v0.10.2/bohay-v0.10.2-x86_64-unknown-linux-musl.tar.gz"
      sha256 "70f659eb52b8a07645ee5abc2e8d4910a449df08bd15aa1fe002719794fbaf31"
    end
    on_arm do
      url "https://github.com/RizRiyz/bohay/releases/download/v0.10.2/bohay-v0.10.2-aarch64-unknown-linux-musl.tar.gz"
      sha256 "ef009088741846099969dd13f316322c43285ffe1436d777e8e1af8954a6503a"
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
