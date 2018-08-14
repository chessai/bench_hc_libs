# Repo for semi automatic benchmarking of my Code Layout patch.

## Methodology

Results are speedup in %: `(OldTime*100)/NewTime`, calculated by taking the geometric mean
of all criterion benchmarks provided by the package.

Nofib results are results from multiple nofib runs aggregated via geometric mean.

Benchmark times are determined by building the benchmark and all dependencies using the new/old layout
algorithm.
Then running the benchmarks and exporting the result to csv taking the given mean as result.

Three variants of the new code layout were run. Results are comparisons against the one not considering
calls for layout unless stated otherwise.

Commit ids reference my [GHC fork](https://github.com/AndreasPK/ghc/tree/layoutOpt) and might not stay valid if I perform rebases or similar cleanup work.

### Speedup Results - Commit 619d38e73a31409b7eeacc2521f71e57264c67e0

Higher is better

| Library       | Sandy Bridge (Linux) | Haswell (Linux) | Skylake (Win) |
| ------------- |-------------:| -----:| -----: |
| aeson         | +0.8%         | +0.4%         |   NA
| containers    | +0.7%         |       -1.76%  |   *1 +0.2%
| megaparsec    | +0.5%         | +0.4%         |   NA
| text          | +4.0%         | +4.6%         |   NA
| Vector *2     | -2,8%         | -0.9%         |   -1,2%        |
| nofib - compiletime *4| +2.2% |   NA          |   NA
| nofib - runtime *5 | 0.0%          |   NA          |       NA


* *1 Results for the variant which considers calls
* *2 Swings quite a bit (+/-1%) depending on seed used. Only 8 benchmarks. But likely slower with new layout.
* *3 -1.8 if we don't consider calls, + 0.9% if we do.
* *4 Measured by compiling nofib with compilers built with and without the patch.
* *5 There are small changes, but they all amount to less than 0.1%

### Speedup Result - Commit 328f124e

Included in this commit were some changes to the Cmm pipeline.
These changed when we invert if/else branches which was beneficial
for both layout algorithms. Ultimately this was however rolled back
since there were some hard to fix bugs for edge cases.

Higher is better

| Library       | Sandy Bridge (Linux) | Haswell (Linux) | Skylake (Win) |
| ------------- |------------: | ----:      | -----: |
| aeson         | +1.3%        | -0.1%      |   +0.6%
| containers    | +0.8%        | +1.0%      |   +0.6%
| megaparsec    | +2.4%        | +3.5%      |   NA
| text          | +3.0%        | +3.3%      |   NA
| Vector *2     | +0.5%        | +0.8%      |   +1.9%
| nofib | NA

Entries with NA were not measured because of time constraints.
