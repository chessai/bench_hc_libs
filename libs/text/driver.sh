
if [ ! -d "tests" ]; then
  git clone https://github.com/bos/text-test-data.git
  mkdir tests
  mv text-test-data tests/
fi

cd tests/text-test-data/
make
cd ../..

for compiler in allCalls;
#for compiler in adjusted  allCalls  head  noCalls  someCalls  vanilla
do
    unameOut="$(uname -s)"
    case $unameOut in
    MINGW*)
        HC="C:\\ghc\\msys64\\home\\Andi\\trees\\${compiler}\\inplace\\bin\\ghc-stage2.exe" ;;
    *)
        HC=~/trees/${compiler}/inplace/bin/ghc-stage2 ;;
    esac

    mkdir "c_${compiler}" -p
    cp bench.sh "c_${compiler}"
    cp cabal.project "c_${compiler}"
    cd "c_${compiler}"
    bash bench.sh "$HC"
    cd ..
done
