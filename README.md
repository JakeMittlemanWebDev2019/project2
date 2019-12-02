# (Trans/Re)late

## API Instructions
1. Set Environment Variable each time console opens. The PATH should be the path to the Service Account key file.
  - Mac: export GOOGLE_APPLICATION_CREDENTIALS="[PATH]"
  - Windows: $env:GOOGLE_APPLICATION_CREDENTIALS="[PATH]"
  
2. Put the Service Account key file in the parent directory of the project.
  - For example: My file structure is Project2/trans so I put it in Project2


## Description
(Trans/Re)late is a multi-lingual chatting app that auto-translates messages so it appears as if all participants are speaking the same language.

## Team Members
1. Jon Anton
2. Kevin Gendron
3. Marielle Riveros
4. Jake Mittleman

## Git Workflow

- git branch <your branch name>
- git checkout <your branch name>
- Do some work
- git add <files>
- git commit -m <message>
- git push origin <your branch name>
- Create a PR (pull request)
- If you want someone to look at your code, tag them, otherwise merging is fine
- delete remote branch
- delete local branch
- git pull (from master)
  
## Install React??

- npm install --save-dev @babel/preset-env @babel/preset-react
- npm install --save react react-dom
- npm install --save lodash jquery

## Install Bootstrap and deps.

npm install --save bootstrap jquery popper.js

npm install --save-dev node-sass sass-loader

npm install --save-dev node-gyp

npm install --save-dev fibers

npm install --save-dev webpack@^4.36.0

npm audit fix --force

## Prep for deployment

Impacted Files:

- [ ] -prod.exs /config
- [ ] -prod.secret.exs /config
- [ ] -deploy.sh /
- [ ] -trans.nginx /
- [ ] -trans.service /
- [ ] -start.sh /
- [ ] -prod-env.sh /

Commands:

$ mix release.init
$ mix deps.get
$ (cd assets && npm install)
$ mix phx.gen.secret (add to prod-env.sh)
$ . prod-env.sh
$ mix ecto.create
# cd /etc/nginx/sites-enabled
# ln -s /etc/nginx/sites-available/lens.ironbeard.com .
# service nginx restart
# cp lens.service /etc/systemd/system
# systemctl enable lens.service
# service lens start
# service lens status


