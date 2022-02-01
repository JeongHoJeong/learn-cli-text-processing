#!/usr/bin/env bash
{
  function finish {
    # Restore screen
    tput rmcup

    echo 'bye!'
  }

  trap finish EXIT

  # Save screen
  # http://linuxcommand.org/lc3_adv_tput.php
  tput smcup

  # https://stackoverflow.com/a/2924755/5945418
  bold=$(tput bold)
  red=$(tput setaf 1)
  blue=$(tput setaf 2)
  cyan=$(tput setaf 6)
  normal=$(tput sgr0)

  echo -e "${bold}hi, welecome to the command-line text processing journey.${normal}\n"

  exercises=()

  function get_exercises {
    while read path; do
      exercises+=($path)
    done < <(cd exercises && ls *.e)
  }

  function pick_random_exercise_id {
    idx=$(NUM_EXERCISES=${#exercises[@]} perl -e 'print int rand() * $ENV{NUM_EXERCISES}')
    exercise_id=${exercises[$idx]}
  }

  function get_io_files {
    exercise_file=exercises/${exercise_id}
    in_file=inputs/$(head -1 $exercise_file)
    out_file=outputs/$(head -2 $exercise_file | tail -1)
  }

  get_exercises
  pick_random_exercise_id
  get_io_files

  # TODO: provide an option to choose an exercise
  echo "exercise_id: $exercise_id"

  # TODO: use system tmp dir
  result_path=tmp/result

  echo -e "\n${bold}${cyan}input:${normal}"
  cat $in_file

  echo -e "\n${bold}${cyan}output:${normal}"
  cat $out_file

  has_diff=1

  while [[ $has_diff -eq 1 ]];
  do
    echo -e "\n${bold}${cyan}show your answer:${normal}"
    read answer
    # TODO: cleanup files
    eval "cat $in_file | $answer > $result_path"

    echo -e "\n${bold}${cyan}your result:${normal}"
    cat $result_path

    echo -e "\n${bold}${cyan}diff:${normal}"

    if ! diff $out_file $result_path; then
      echo -e "\n${red}diff found. try again!${normal}"
    else
      # TODO: provide a way to keep doing it
      echo -e "\n${blue}excellent! no diff found.${normal}"
      has_diff=0
    fi

  done

  echo -e '\n'
  # https://unix.stackexchange.com/a/293941
  read -n 1 -s -r -p "type anything to exit."
}
