class Archiver < Formula
  desc "Cross-platform, multi-format archive utility"
  homepage "https://github.com/mholt/archiver"
  url "https://github.com/mholt/archiver/archive/refs/tags/v3.5.1.tar.gz"
  sha256 "b69a76f837b6cc1c34c72ace16670360577b123ccc17872a95af07178e69fbe7"
  license "MIT"
  head "https://github.com/mholt/archiver.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89e35201ceb871d42452fa16d9bb0210e3eaed8452fa345c7b37f7c9b8b20f3a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89e35201ceb871d42452fa16d9bb0210e3eaed8452fa345c7b37f7c9b8b20f3a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "89e35201ceb871d42452fa16d9bb0210e3eaed8452fa345c7b37f7c9b8b20f3a"
    sha256 cellar: :any_skip_relocation, sonoma:        "653903fc5c0b2f7a72abcc894d585c786438d8577a62bb81e1f2e2687a6c397a"
    sha256 cellar: :any_skip_relocation, ventura:       "653903fc5c0b2f7a72abcc894d585c786438d8577a62bb81e1f2e2687a6c397a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a861459806781f7ed95d10fe9c1c9aff1f263c50d7c4ab07881c1556c89fce46"
  end

  deprecate! date: "2025-04-27", because: :repo_archived

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"arc"), "./cmd/arc"
  end

  test do
    output = shell_output("#{bin}/arc --help 2>&1")
    assert_match "Usage: arc {archive|unarchive", output

    (testpath/"test1").write "Hello!"
    (testpath/"test2").write "Bonjour!"
    (testpath/"test3").write "Moien!"

    system bin/"arc", "archive", "test.zip",
           "test1", "test2", "test3"

    assert_path_exists testpath/"test.zip"
    assert_match "Zip archive data",
                 shell_output("file -b #{testpath}/test.zip")

    output = shell_output("#{bin}/arc ls test.zip")
    names = output.lines.map do |line|
      columns = line.split(/\s+/)
      File.basename(columns.last)
    end
    assert_match "test1 test2 test3", names.join(" ")
  end
end
