class Hourglass < Formula
  desc "Self-hosted web UI for managing Linux and macOS cron jobs"
  homepage "https://github.com/TillmanBuildsTech/hourglass"
  url "https://github.com/TillmanBuildsTech/hourglass/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "2459527d386c105a0c07a46b24b9a1ce39a6100c5d402a13bfe4922fe283f9f4"
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
