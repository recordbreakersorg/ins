#!/usr/bin/fish

function deploy
    echo "[manage.fish] Deploying on firebase "
    firebase deploy
end
function build-web
    echo "[manage.fish] Building for the web"
    flutter build web --no-web-resources-cdn --optimization-level 4
end
function build-apk
    echo "[manage.fish] Building apk"
    flutter build apk --release --tree-shake-icons --split-debug-info build/android/debug-info/v1.0.0/ --obfuscate
end
function watch
    echo "[launching arb-util]"
    arb-util run
end

set usage "manage deploy|build-web|watch|build-apk|fire"

if test $argv[1] = deploy
    deploy
else if test "$argv[1]" = build-web
    build-web
else if test "$argv[1]" = fire
    build-web
    deploy
else if test "$argv[1]" = watch
    watch
else if test "$argv[1]" = build-apk
    build-apk
else
    echo $usage
end
