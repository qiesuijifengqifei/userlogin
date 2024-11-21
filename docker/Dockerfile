FROM alpine

COPY userlogin config.ini /work/

WORKDIR /work
EXPOSE 8000
LABEL org.opencontainers.image.source https://github.com/qiesuijifengqifei/userlogin
# 启动命令
ENTRYPOINT [ "/work/userlogin" ]