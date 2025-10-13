function gc --wraps='git add . && git commit && git push' --description 'alias gc=git add . && git commit && git push'
    git add . && git commit && git push $argv
end
