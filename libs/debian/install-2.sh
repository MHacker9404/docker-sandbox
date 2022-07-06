sudo curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
source $HOME/.bashrc

nvm install --lts

npm install -g npm && npm --version && \
    npm install -g yarn && yarn --version && \
    npm install -g typescript @typescript-eslint/parser vue-eslint-parser && tsc --version && \
    npm install -g npm-check-updates && ncu --version && \
    npm install -g newman && newman --version&& \
    npm install -g @nrwl/cli nx