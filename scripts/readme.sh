#!/bin/bash

cd src
examples=$(ls -d -- */)
cd ..
for example in $examples; do
    let len=(${#example} - 1)
    ex=(${example::$len})
    line="- [$ex](src/$ex) - [Preview](preview/${ex}.gif)"
    echo $line >> README.md
done