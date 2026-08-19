# Homebrew formula for luvus.
#
# Installs the **prebuilt binary** from the GitHub release, so `brew install`
# is a ~3 MB download with no Rust toolchain and no compile step. Building the
# 100+ crate dependency graph from source peaks well over a gigabyte of RAM,
# which is exactly what people install a binary to avoid.
#
# Every platform we publish gets a prebuilt binary, Intel macs included (the
# release cross-compiles x86_64 on an Apple-silicon runner).
#
#   brew install RizRiyz/luvus/luvus
#   brew install --HEAD RizRiyz/luvus/luvus   # build the tip of main
#
# `scripts/release.sh` rewrites the version + every sha256 below from the
# release's published `.sha256` assets — don't hand-edit them.
class Luvus < Formula
  desc "Mission control for your AI coding agents"
  homepage "https://github.com/RizRiyz/luvus"
  version "0.11.0"
  license "MIT"
  head "https://github.com/RizRiyz/luvus.git", branch: "main"

  # Deliberately no `depends_on "git"` / `"gh"`. luvus only *shells out* to them:
  # git powers the git tab + worktrees, gh adds GitHub PRs/issues, and the
  # multiplexer runs fine without either (`luvus doctor` reports what's missing).
  # Declaring them would drag Homebrew's own git onto machines that already have
  # the system one, which defeats the point of a 3 MB binary install.

  on_macos do
    on_arm do
      url "https://github.com/RizRiyz/luvus/releases/download/v0.11.0/homebrew-luvus/Formula/luvus.rbe108e2755fdc35dc9a4d5914ddaac30ab5af6b4c35a0af5372de87026b68cf84"
    end
    on_intel do
      url "https://github.com/RizRiyz/luvus/releases/download/v0.11.0/homebrew-luvus/Formula/luvus.rbfccba0b928b983d7a03efd8730bd2a2dd72c14d29abf799c92d4d71829df123d"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/RizRiyz/luvus/releases/download/v0.11.0/homebrew-luvus/Formula/luvus.rb5c1192b1b48a8ce7cb969926b382470e114999ffe2a13a96e2b23fe4a6223ad0"
    end
    on_arm do
      url "https://github.com/RizRiyz/luvus/releases/download/v0.11.0/homebrew-luvus/Formula/luvus.rbf2b45d1f5f588f436797c82dcb6998d84c4cc67ec5cfdfa829fd9a131c867e65"
    end
  end

  def install
    # `--HEAD` builds from a source checkout; every release path unpacks an
    # archive with the binary at its root.
    if build.head?
      system "cargo", "install", *std_cargo_args
    else
      bin.install "luvus"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/luvus --version")
  end
end
