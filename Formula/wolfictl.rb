class Wolfictl < Formula
  desc "CLI used to work with the Wolfi OSS project"
  homepage "https://github.com/wolfi-dev/wolfictl"
  url "https://github.com/wolfi-dev/wolfictl/archive/refs/tags/v0.24.7.tar.gz"
  sha256 "436ae48abe705a83c4fd9cec079001679393630c8b3dd1a04c7ea2c584601a6c"
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
    (testpath/"test.yaml").write <<~EOS
      package:
        name: melange
        version: 0.9.0
        epoch: 0
        description: build APKs from source code
        copyright:
          - license: Apache-2.0
        dependencies:
          runtime:
            - bubblewrap
            - ca-certificates-bundle

      environment:
        contents:
          packages:
            - busybox
            - ca-certificates-bundle
            - go

      pipeline:
        - uses: git-checkout
          with:
            expected-commit: 2923188101d8fb20495e119850ad266d865cb8cd
            repository: https://github.com/chainguard-dev/melange
            tag: v${{package.version}}

        - runs: |
            make melange
            install -m755 -D ./melange "${{targets.contextdir}}"/usr/bin/melange

        - uses: strip

      update:
        enabled: true
        github:
          identifier: chainguard-dev/melange
          strip-prefix: v
          use-tag: true

      test:
        environment:
          contents:
            packages:
              - apk-tools
        pipeline:
          - runs: |
              apk del wolfi-base busybox
              melange version

              # busybox is needed for the build, but we want to demonstrate
              # that it's not needed at runtime.
              # TODO(jason): Can't currently test this due to container inception nonsense that's just too crazy to justify.
              # melange build example.yaml --arch=x86_64
    EOS

    assert_equal "found 1 packages\n", shell_output("#{bin}/wolfictl lint #{testpath}/test.yaml")

    # system bin/"melange", "keygen"
    # assert_predicate testpath/"melange.rsa", :exist?

    assert_match version.to_s, shell_output(bin/"wolfictl version 2>&1")
  end
end
