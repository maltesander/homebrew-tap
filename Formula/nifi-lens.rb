class NifiLens < Formula
  desc "A keyboard-driven TUI lens into Apache NiFi 2.x. Browse flows, trace flowfiles, tail bulletins, and debug across clusters and versions."
  homepage "https://github.com/maltesander/nifi-lens"
  version "0.11.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/maltesander/nifi-lens/releases/download/v0.11.0/nifi-lens-aarch64-apple-darwin.tar.xz"
      sha256 "8bfde6bcc4801ba94a9134bf00d360de2f0b93b35b2a6f6be679888a03a6e31a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/maltesander/nifi-lens/releases/download/v0.11.0/nifi-lens-x86_64-apple-darwin.tar.xz"
      sha256 "48d2780ba94206ef13ae8bea5c55e9164de31c508d7547a68cfa507e52464a84"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/maltesander/nifi-lens/releases/download/v0.11.0/nifi-lens-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5b5695329015302d72589caacc7c25314d9df622cf52672f02ed39cbbcdf137a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/maltesander/nifi-lens/releases/download/v0.11.0/nifi-lens-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e0dfae41da40c514919b2e8378e0ebe787973acbadf8d9def40b742bcbfa0f70"
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
