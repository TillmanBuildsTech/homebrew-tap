class Hourglass < Formula
  desc "Self-hosted web UI for managing Linux and macOS cron jobs"
  homepage "https://github.com/TillmanBuildsTech/hourglass"
  url "https://github.com/TillmanBuildsTech/hourglass/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "ea274cfa43e8ef56328f6815c5b27ae867a2c9602fc3cd9162f8f1ee3dcb8210"
  license "MIT"

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    cd "ui" do
      system "npm", "install"
      system "npm", "run", "build"
    end
    system "go", "build", *std_go_args(ldflags: "-s -w"), "."
  end

  test do
    assert_match "hourglass v#{version}", shell_output("#{bin}/hourglass --version")
  end
end
