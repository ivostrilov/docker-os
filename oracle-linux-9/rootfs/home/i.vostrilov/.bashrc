if [ -f /etc/bashrc ]; then
	source /etc/bashrc
fi

configure_locale() {
  export LANG=ru_RU.utf8
  export LC_ALL=ru_RU.utf8
}

export_path() {
  local MY_HOME_BIN="$HOME/bin"

  my_paths=(
    "$MY_HOME_BIN"
    "$HOME/.local/bin"
    "/home/i.vostrilov/my-packages/LLVM-20.1.2-Linux-ARM64/bin"
  )

  for my_path in "${my_paths[@]}"; do
    if [[ ":$PATH:" != *":$my_path:"* ]]; then
      export PATH="$my_path:$PATH"
    fi
  done
}

main() {
  configure_locale
  export_path
}

main "$@"
