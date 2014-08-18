#!/usr/bin/env rake

task :ci => [:dump, :test]

task :dump do
    sh 'vim --version'
end

task :test do
    sh <<'...'
if ! [ -d .vim-test/ ]; then
    mkdir .vim-test/
    git clone https://github.com/vim-jp/vital.vim .vim-test/vital.vim/
fi
...
    sh 'bundle exec vim-flavor test'
end
