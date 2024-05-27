class Wolfictl < Formula
  desc "CLI used to work with the Wolfi OSS project"
  homepage "https://github.com/wolfi-dev/wolfictl"
  url "https://github.com/wolfi-dev/wolfictl/archive/refs/tags/v0.16.13.tar.gz"
  sha256 "263e741fb9f2bc9e12b0f8b70645efa84a54e81f3422a8e6aa90e6ad643f01d2"
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
