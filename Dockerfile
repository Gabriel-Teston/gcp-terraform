FROM hashicorp/terraform:latest

RUN apk --no-cache add curl bash python3 which
RUN curl -sSL https://sdk.cloud.google.com > /tmp/gcl && bash /tmp/gcl --install-dir=~/gcloud --disable-prompts

ENV PATH $PATH:~/gcloud/google-cloud-sdk/bin