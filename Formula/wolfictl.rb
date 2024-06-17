class Wolfictl < Formula
  desc "CLI used to work with the Wolfi OSS project"
  homepage "https://github.com/wolfi-dev/wolfictl"
  url "https://github.com/wolfi-dev/wolfictl/archive/refs/tags/v0.17.1.tar.gz"
  sha256 "bb1b19c50b34e34e96ed45b61497a90126023763be8ad99526ba693883b2071a"
  license "Apache-2.0"
  head "https://github.com/wolfi-dev/wolfictl.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X sigs.k8s.io/release-utils/version.gitVersion=#{version}
      -X sigs.k8s.io/release-utils/version.gitCommit=#{tap.user}
      -X sigs.k8s.io/release-utils/version.gitTreeState=#{tap.user}
      -X sigs.k8s.io/release-utils/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"wolfictl", "completion")
  end

  test do
    system bin/"wolfictl"
  end
end
