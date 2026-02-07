#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install

# node_modules が空、あるいは tailwindcss がない場合に強制インストール
if [ ! -d "node_modules" ] || [ ! -f "node_modules/.bin/tailwindcss" ]; then
  echo "Installing JavaScript dependencies..."
  # Bunがインストールされている環境（Renderの最新）を想定
  if command -v bun &> /dev/null; then
    bun install
  else
    npm install
  fi
fi

bundle exec rails assets:precompile
bundle exec rails assets:clean
bundle exec rails db:migrate