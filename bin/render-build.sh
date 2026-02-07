#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install

# JavaScript/CSSの依存関係をインストール（これを追加！）
if [ -f "bun.lockb" ]; then
  bun install
elif [ -f "yarn.lock" ]; then
  yarn install
else
  npm install
fi

bundle exec rails assets:precompile
bundle exec rails assets:clean
bundle exec rails db:migrate