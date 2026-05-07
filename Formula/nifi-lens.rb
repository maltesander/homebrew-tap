class NifiLens < Formula
  desc "A keyboard-driven TUI lens into Apache NiFi 2.x. Browse flows, trace flowfiles, tail bulletins, and debug across clusters and versions."
  homepage "https://github.com/maltesander/nifi-lens"
  version "0.10.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/maltesander/nifi-lens/releases/download/v0.10.0/nifi-lens-aarch64-apple-darwin.tar.xz"
      sha256 "c61d8b7c06bf4562c951cc2037ea0d5528f1275873c29d1eb44f90f3034c80a3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/maltesander/nifi-lens/releases/download/v0.10.0/nifi-lens-x86_64-apple-darwin.tar.xz"
      sha256 "2c5e1aea07e8edf8c57606c9c68158f3a2d5a78ac11d2b56f5f44cb8a7268f83"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/maltesander/nifi-lens/releases/download/v0.10.0/nifi-lens-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "cc6922eaf1e9e92daaa7fe460e27a3c8322db6c68151440d6609c6ed18e781c4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/maltesander/nifi-lens/releases/download/v0.10.0/nifi-lens-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5706fe1a030294e5b1fce05c0ade98818b504adff892dd02e5159b6344868d32"
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
