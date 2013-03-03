require 'formula'

class Scalapack < Formula
  homepage 'http://www.netlib.org/scalapack/'
  url 'http://www.netlib.org/scalapack/scalapack-2.0.2.tgz'
  sha1 'ff9532120c2cffa79aef5e4c2f38777c6a1f3e6a'

  option 'test', 'Verify the build with make test'
  option 'with-openblas', "Use openblas instead of Apple's Accelerate.framework"

  depends_on MPIDependency.new(:cc, :f90)
  depends_on 'cmake' => :build
  depends_on 'dotwrp' unless build.include? 'with-openblas'
  depends_on 'homebrew/science/openblas' if build.include? 'with-openblas'

  def install
    ENV.fortran

    if build.include? 'with-openblas'
      args = std_cmake_args + [
        '-DBLAS_LIBRARIES=-lopenblas',
        '-DLAPACK_LIBRARIES=-lopenblas',
      ]
    else
      args = std_cmake_args + [
        '-DBLAS_LIBRARIES=-ldotwrp -Wl,-framework -Wl,Accelerate',
        '-DLAPACK_LIBRARIES=-ldotwrp -Wl,-framework -Wl,Accelerate',
      ]
    end

    mkdir "build" do
      system 'cmake', '..', *args
      system 'make all'
      system 'make test' if build.include? 'test'
      system 'make install'
    end
  end
end
