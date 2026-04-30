class NifiLens < Formula
  desc "A keyboard-driven TUI lens into Apache NiFi 2.x. Browse flows, trace flowfiles, tail bulletins, and debug across clusters and versions."
  homepage "https://github.com/maltesander/nifi-lens"
  version "0.9.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/maltesander/nifi-lens/releases/download/v0.9.0/nifi-lens-aarch64-apple-darwin.tar.xz"
      sha256 "37201430fbe5d086b105a2e882d9184bede9789fa26f2b246d31d3e8a4635627"
    end
    if Hardware::CPU.intel?
      url "https://github.com/maltesander/nifi-lens/releases/download/v0.9.0/nifi-lens-x86_64-apple-darwin.tar.xz"
      sha256 "c48b1ce71d33fea5a9231d225714af22810155322b055f3891fced21d2150042"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/maltesander/nifi-lens/releases/download/v0.9.0/nifi-lens-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "51b7bfd3c58ed20a564b0f1a3b2fc4af20fa5781c14b9d316810a9068aa8aff7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/maltesander/nifi-lens/releases/download/v0.9.0/nifi-lens-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "097e4e87e90996faa866880b04ce1c0e4957f2cc0eda6462ba5849411d6136a0"
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
