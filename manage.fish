#!/usr/bin/fish

function deploy
    echo "[manage.fish] Deploying on firebase "
    firebase deploy
end
function build-web
    echo "[manage.fish] Building for the web"
    flutter build web --no-web-resources-cdn --optimization-level 4 --wasm
end

set usage "manage deploy|build-web"

if test $argv[1] = deploy
    deploy
else if test $argv[1] = build-web
    build-web
else if test $argv[1] = fire
    build-web
    deploy
else
    echo $usage
end
