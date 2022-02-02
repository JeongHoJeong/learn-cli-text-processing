#!/usr/bin/env bash
{
  function finish {
    rmdir $tmpdir
  }
  trap finish EXIT

  tmpdir=$(mktemp -d 2>/dev/null || mktemp -d -t 'learn-cli-tp-test-tmp')

  while read p ; do
    echo "running test: $p..."
    cmd=$(tail +3 < $p | head -1)

    if [[ -z $cmd ]]; then
      echo "$p is missing an example command."
      exit 1
    fi

    input_file="inputs/$(head -1 < $p)"
    output_file="outputs/$(tail +2 < $p | head -1)"

    tmpfile="$tmpdir/res"
    final_cmd="cat $input_file | $cmd > $tmpfile"

    eval $final_cmd

    if ! diff $tmpfile $output_file; then
      echo "test failed: ${p}"
      test_failed=1
    fi

    rm $tmpfile

    if [[ $test_failed -eq 1 ]]; then
      exit 1
    fi
  done < <(ls exercises/*.e)

  echo "all tests are done successfully."
}
