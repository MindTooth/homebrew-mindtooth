class Wolfictl < Formula
  desc "CLI used to work with the Wolfi OSS project"
  homepage "https://github.com/wolfi-dev/wolfictl"
  url "https://github.com/wolfi-dev/wolfictl/archive/refs/tags/v0.16.12.tar.gz"
  sha256 "745961f014af2695514a18af9893fbcb9df822cb69cbf6d4cf1378e92c25f4db"
  head "https://github.com/wolfi-dev/wolfictl.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"wolfictl", "completion")
  end

  test do
    system bin/"wolfictl"
  end
end
