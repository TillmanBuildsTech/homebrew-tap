class Hourglass < Formula
  desc "Self-hosted web UI for managing Linux and macOS cron jobs"
  homepage "https://github.com/TillmanBuildsTech/hourglass"
  url "https://github.com/TillmanBuildsTech/hourglass/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "8c33dcd5db873b1e8a9d13f49eda14aabb95c0ed283eda1920a3fbd0234ef089"
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
  # Defaults to a loopback bind (safe, no credentials needed).
  # To expose on your LAN at http://hourglass.local:8080, edit
  # ~/Library/LaunchAgents/homebrew.mxcl.hourglass.plist to set
  # HOURGLASS_BIND=0.0.0.0:8080 plus HOURGLASS_AUTH_USER and
  # HOURGLASS_AUTH_PASS, then .
  # (Hourglass refuses to serve on non-loopback binds without
  # credentials — see bind_security.go.)
  service do
    run [opt_bin/"hourglass"]
    keep_alive true
    log_path var/"log/hourglass.log"
    error_log_path var/"log/hourglass.log"
    environment_variables HOURGLASS_BIND: "127.0.0.1:8080"
  end

  test do
    assert_match "hourglass v#{version}", shell_output("#{bin}/hourglass --version")
  end
end
