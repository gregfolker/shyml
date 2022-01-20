#!/usr/bin/env bash

main() {
   local src="`pwd`/shyml.sh"
   local dest="/usr/local/bin/shyml"
   ln -sf $src $dest \
      && echo "Done."
}

main "$@"
