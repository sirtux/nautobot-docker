FROM python:3.12-bullseye

ARG VERSION_NAUTOBOT
ENV VERSION $VERSION_NAUTOBOT

ENV NAUTOBOT_ROOT "/opt/nautobot"
ENV PATH "$NAUTOBOT_ROOT/bin:$PATH"

RUN apt-get update && apt-get install -y \
  git \
  sudo \
  && rm -rf /var/lib/apt/lists/*

RUN useradd --system --shell /bin/bash --create-home --home-dir $NAUTOBOT_ROOT nautobot
RUN sudo -u nautobot python3 -m venv $NAUTOBOT_ROOT
RUN echo "export NAUTOBOT_ROOT=$NAUTOBOT_ROOT" | sudo tee -a ~nautobot/.bashrc

USER nautobot

RUN pip3 install --upgrade pip wheel
RUN pip3 install "nautobot==$VERSION"
RUN pip3 install nautobot-bgp-models

CMD ["nautobot-server", "--version"]
