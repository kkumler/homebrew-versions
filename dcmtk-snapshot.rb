require 'formula'

# Formula copied from dcmtk formula
class DcmtkSnapshot < Formula
  homepage 'http://dicom.offis.de/dcmtk.php.en'
  url 'http://dicom.offis.de/download/dcmtk/snapshot/dcmtk-3.6.1_20140617.tar.gz'
  version "3.6.1-20140617"
  sha256 'c0aab5a3809e20f8b4eae2f181c77a1668d0665e86a590821a59808f45656cdc'

  bottle do
    sha1 "8c89405648fc176e34716a6e786444da20765b12" => :yosemite
  end

  option 'with-docs', 'Install development libraries/headers and HTML docs'
  option 'with-openssl', 'Configure DCMTK with support for OpenSSL'

  depends_on 'cmake' => :build
  depends_on "libpng"
  depends_on 'libtiff'
  depends_on "doxygen" => :build if build.with? "docs"

  conflicts_with "dcmtk", :because => "Differing versions of same package"

  def install
    ENV.m64 if MacOS.prefer_64_bit?

    args = std_cmake_args
    args << '-DDCMTK_WITH_DOXYGEN=YES' if build.with? "docs"
    args << '-DDCMTK_WITH_OPENSSL=YES' if build.with? "openssl"
    args << '..'

    mkdir 'build' do
      system 'cmake', *args
      system 'make DOXYGEN' if build.with? "docs"
      system 'make install'
    end
  end
end
