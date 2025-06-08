class Wartremover < Formula
  desc "Flexible Scala code linting tool"
  homepage "https://github.com/wartremover/wartremover"
  url "https://github.com/wartremover/wartremover/archive/refs/tags/v3.3.5.tar.gz"
  sha256 "773e4762a61c4ac8afe259ab8bab3178eea07693c5493994bc204c9f091d3f5e"
  license "Apache-2.0"
  head "https://github.com/wartremover/wartremover.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "acec7256e71f6503a1de7b7c340eaf0e461dfd4c0037fbc8c1e42b45f74916b1"
  end

  depends_on "sbt" => :build
  depends_on "openjdk"

  def install
    # fix `java.lang.OutOfMemoryError: Java heap space` issue during `assembly`
    ENV["SBT_OPTS"] = "-Xmx4G -XX:+UseG1GC"
    system "sbt", "assembly"
    libexec.install "wartremover-assembly.jar"
    bin.write_jar_script libexec/"wartremover-assembly.jar", "wartremover"
  end

  test do
    (testpath/"foo").write <<~EOS
      object Foo {
        def foo() {
          var msg = "Hello World"
          println(msg)
        }
      }
    EOS
    cmd = "#{bin}/wartremover -traverser org.wartremover.warts.Unsafe foo 2>&1"
    assert_match "var is disabled", shell_output(cmd, 1)
  end
end
