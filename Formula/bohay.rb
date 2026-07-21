# Homebrew formula for bohay. Build-from-source (pure Rust, no system libs).
#
# Quickest path (works right now, no release needed):
#   brew install --HEAD RizRiyz/bohay/bohay
#
# Stable releases: after you `git tag v0.1.0 && git push --tags`, set `sha256`
# below to the tag tarball's checksum:
#   curl -sL https://github.com/RizRiyz/bohay/archive/refs/tags/v0.8.0.tar.gz | shasum -a 256
class Bohay < Formula
  desc "Terminal multiplexer for AI coding agents"
  homepage "https://github.com/RizRiyz/bohay"
  url "https://github.com/RizRiyz/bohay/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "801dfb6b229d91968794abf08befeadf9c883beaa292c3174d5186c91e1516ae"
  license "MIT"
  head "https://github.com/RizRiyz/bohay.git", branch: "main"

  depends_on "rust" => :build
   # Runtime tools bohay shells out to. `git` powers the git tab + worktrees; `gh`
  # adds GitHub PRs/issues (bohay still works as a local-git viewer without it).
  # (For a homebrew-core submission, drop `git` - core assumes a system git.)
  depends_on "git"
  depends_on "gh"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bohay --version")
  end
end
