# Homebrew formula for bohay. Build-from-source (pure Rust, no system libs).
#
# Quickest path (works right now, no release needed):
#   brew install --HEAD RizRiyz/bohay/bohay
#
# Stable releases: after you `git tag v0.1.0 && git push --tags`, set `sha256`
# below to the tag tarball's checksum:
#   curl -sL https://github.com/RizRiyz/bohay/archive/refs/tags/v0.5.0.tar.gz | shasum -a 256
class Bohay < Formula
  desc "Terminal multiplexer for AI coding agents"
  homepage "https://github.com/RizRiyz/bohay"
  url "https://github.com/RizRiyz/bohay/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "07514fba6178113c1b76d0dfc9b6f86db37efda7ae4aff241b6c860ae24ef217"
  license "MIT"
  head "https://github.com/RizRiyz/bohay.git", branch: "main"

  depends_on "rust" => :build
   # Runtime tools bohay shells out to. `git` powers the git tab + worktrees; `gh`
  # adds GitHub PRs/issues (bohay still works as a local-git viewer without it).
  # (For a homebrew-core submission, drop `git` — core assumes a system git.)
  depends_on "git"
  depends_on "gh"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bohay --version")
  end
end
