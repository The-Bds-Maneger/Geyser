FROM debian:latest

# Package Base
ARG DEBIAN_FRONTEND="noninteractive"
RUN apt update && \
  apt install -y openjdk-17-jre openjdk-17-jdk git wget curl gnupg gpg tar zip unzip jq zsh sudo

# Install gradle
RUN cd /tmp && wget -q "$(wget -qO- https://services.gradle.org/versions/current | jq -r '.downloadUrl')" -O gradlw.zip && unzip gradlw.zip -d ./ && \
  cd gradle-* && cp -rf * /usr && \
  gradle -v && cd /tmp && rm -rf *

# docker install
RUN wget -qO- https://get.docker.com | sh && \
  wget -q $(wget -qO- https://api.github.com/repos/docker/compose/releases/latest | grep 'browser_download_url' | grep -v '.sha' | cut -d '"' -f 4 | grep linux | grep $(uname -m) | head -n 1) -O /usr/local/bin/docker-compose && chmod +x -v /usr/local/bin/docker-compose

# User
ARG USERNAME="devcontainer"
ARG USER_UID="1000"
ARG USER_GID=$USER_UID
RUN groupadd --gid $USER_GID $USERNAME && \
  adduser --disabled-password --gecos "" --shell /usr/bin/zsh --uid $USER_UID --gid $USER_GID $USERNAME && \
  echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$USERNAME && \
  chmod 0440 /etc/sudoers.d/$USERNAME && \
  usermod -aG sudo $USERNAME && \
  usermod -aG docker $USERNAME

# Install docker start
COPY ./startDocker.sh /usr/bin/startDocker.sh
RUN chmod a+x /usr/bin/startDocker.sh

USER $USERNAME
WORKDIR /home/$USERNAME
RUN yes | sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" && \
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting && \
  git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions && \
  sed -e 's|ZSH_THEME=".*"|ZSH_THEME="strug"|g' -i ~/.zshrc && \
  sed -e 's|plugins=(.*)|plugins=(git docker zsh-syntax-highlighting zsh-autosuggestions)|g' -i ~/.zshrc

ENTRYPOINT [ "startDocker.sh" ]