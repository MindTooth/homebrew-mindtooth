class Wolfictl < Formula
  desc "CLI used to work with the Wolfi OSS project"
  homepage "https://github.com/wolfi-dev/wolfictl"
  url "https://github.com/wolfi-dev/wolfictl/archive/refs/tags/v0.16.11.tar.gz"
  sha256 "b8191f991aa075e85797c25aca45199035803d1442964e3816eb6213b56ed735"
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
