class Hourglass < Formula
  desc "Self-hosted web UI for managing Linux and macOS cron jobs"
  homepage "https://github.com/TillmanBuildsTech/hourglass"
  url "https://github.com/TillmanBuildsTech/hourglass/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "647878eb2e185e610a2d3868c9536d2903bc56697a6c2a4abfce77ca37d1bdb3"
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

  # brew services start hourglass — runs as a launchd agent.
  # v0.13.0+: the app defaults to a LAN-reachable bind (0.0.0.0:8080)
  # with mDNS advertisement, so hourglass.local works out of the box
  # from any device (the Home Assistant model). On first run a random
  # password is generated and printed to the log (saved in
  # ~/.hourglass/auth.env) — the instance is never served
  # unauthenticated. To force loopback-only, set
  # HOURGLASS_BIND=127.0.0.1:8080 in
  # ~/Library/LaunchAgents/homebrew.mxcl.hourglass.plist (no
  # credentials needed for loopback), then .
  service do
    run [opt_bin/"hourglass"]
    keep_alive true
    log_path var/"log/hourglass.log"
    error_log_path var/"log/hourglass.log"
  end

  test do
    assert_match "hourglass v#{version}", shell_output("#{bin}/hourglass --version")
  end
end
