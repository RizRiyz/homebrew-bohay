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
  version "0.9.7"
  license "MIT"
  head "https://github.com/RizRiyz/bohay.git", branch: "main"

  # Deliberately no `depends_on "git"` / `"gh"`. bohay only *shells out* to them:
  # git powers the git tab + worktrees, gh adds GitHub PRs/issues, and the
  # multiplexer runs fine without either (`bohay doctor` reports what's missing).
  # Declaring them would drag Homebrew's own git onto machines that already have
  # the system one, which defeats the point of a 3 MB binary install.

  on_macos do
    on_arm do
      url "https://github.com/RizRiyz/bohay/releases/download/v0.9.7/bohay-v0.9.7-aarch64-apple-darwin.tar.gz"
      sha256 "9f976cba22eb3bfb206be90d0f7c51b407b25b2988c623d94dc6a0994e68c218"
    end
    on_intel do
      url "https://github.com/RizRiyz/bohay/releases/download/v0.9.7/bohay-v0.9.7-x86_64-apple-darwin.tar.gz"
      sha256 "02904ae1d817a101c2d9769335c6b8d192176be38f35fcc80d62d47200cc709a"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/RizRiyz/bohay/releases/download/v0.9.7/bohay-v0.9.7-x86_64-unknown-linux-musl.tar.gz"
      sha256 "de72bdba27aaf9a3bce66c3b08be6099cd5fa4358576d940a12e843ffd6edb0f"
    end
    on_arm do
      url "https://github.com/RizRiyz/bohay/releases/download/v0.9.7/bohay-v0.9.7-aarch64-unknown-linux-musl.tar.gz"
      sha256 "0cbb8c21e3401832d212c6efbb8a2ff04272191be0183fbd8fa698ae9a8464d5"
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
