# Formula copied from dcmtk formula
class Dcmtk361 < Formula
  homepage "http://dicom.offis.de/dcmtk.php.en"
  url "http://dicom.offis.de/download/dcmtk/snapshot/dcmtk-3.6.1_20140617.tar.gz"
  version "3.6.1-20140617"
  sha256 "c0aab5a3809e20f8b4eae2f181c77a1668d0665e86a590821a59808f45656cdc"

  bottle do
    sha1 "ae36fa23b94d89b8e3d4a986b6f205bc287ce0e1" => :yosemite
  end

  option "with-docs", "Install development libraries/headers and HTML docs"
  option "with-openssl", "Configure DCMTK with support for OpenSSL"
  option "with-libiconv", "Build with libiconv (updated version available from homebrew-dupes)"
  option "with-system-libiconv", "If the default libiconv should be used."

  depends_on "cmake" => :build
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "doxygen" => :build if build.with? "docs"
  depends_on "openssl" => :optional
  depends_on "libiconv" => :optional if build.with? "libiconv" unless build.with? "system-libiconv"

  conflicts_with "dcmtk", :because => "Differing versions of same package"

  def install
    ENV.m64 if MacOS.prefer_64_bit?

    args = std_cmake_args
    args << "-DDCMTK_WITH_DOXYGEN=YES" if build.with? "docs"
    args << "-DDCMTK_WITH_OPENSSL=YES" if build.with? "openssl"
    args << "--with-libiconv" if build.with? "libiconv"
    args << "--with-libiconvinc=" + Formula["libiconv"].opt_prefix.to_s unless build.with? "system-libiconv"
    args << ".."

    mkdir "build" do
      system "cmake", *args
      system "make", "DOXYGEN" if build.with? "docs"
      system "make", "install"
    end
  end
end
