#! /bin/bash

body=$(</dev/stdin)
if [ ! -z "$1" ]
then
    LANG=".$1"
fi

echo \`\`\` {$LANG .numberLines}
echo "$body"
echo \`\`\`