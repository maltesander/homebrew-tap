class NifiLens < Formula
  desc "A keyboard-driven TUI lens into Apache NiFi 2.x. Browse flows, trace flowfiles, tail bulletins, and debug across clusters and versions."
  homepage "https://github.com/maltesander/nifi-lens"
  version "0.8.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/maltesander/nifi-lens/releases/download/v0.8.1/nifi-lens-aarch64-apple-darwin.tar.xz"
      sha256 "cecca3f4d15b4cf2ea7d0b40b0069473cbd25c248dfcd6fe5dae41eddbea8822"
    end
    if Hardware::CPU.intel?
      url "https://github.com/maltesander/nifi-lens/releases/download/v0.8.1/nifi-lens-x86_64-apple-darwin.tar.xz"
      sha256 "96f1ebdecd7164d8a6e9f4a1426a7d0eb0d82767ebc3a747946eb47510c66766"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/maltesander/nifi-lens/releases/download/v0.8.1/nifi-lens-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3912867e24ebb1ff1847b6933e18f649b188a25dbae62defe926cfad82f5cc5a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/maltesander/nifi-lens/releases/download/v0.8.1/nifi-lens-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "08c9fcfbe21ca2f7331bbffe2c2be3cf288c02ab7be541d6b267f134c034e5e3"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "nifilens" if OS.mac? && Hardware::CPU.arm?
    bin.install "nifilens" if OS.mac? && Hardware::CPU.intel?
    bin.install "nifilens" if OS.linux? && Hardware::CPU.arm?
    bin.install "nifilens" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
