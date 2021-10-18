#!/bin/bash

export REACT_APP_ENV=prod
export REACT_APP_API_URL='https://api.example.com'
export REACT_APP_DE_API_URL='https://de.example.com'
export REACT_APP_AUTH_API_URL='https://api.example.com'
export REACT_APP_FORM_API_URL='https://form.example.com'

git clone git@github.com:cosmos-ummc/ummc-admin.git
cd ./ummc-admin
npm ci
npm run build

cd ..
git clone git@github.com:cosmos-ummc/ummc-form.git
cd ./ummc-form
npm ci
npm run build

cd ..
git clone git@github.com:cosmos-ummc/ummc-form-builder.git
cd ./ummc-form-builder
npm ci
npm run build
