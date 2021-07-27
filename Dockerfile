######################################################################################
# Stage 1 - Definindo imagem builder

FROM golang:1.16.6-alpine3.14 AS builder

# Instalando UPX Packer para reduzir o tamanho final do binário
RUN apk update && \
    apk add upx --no-cache

WORKDIR /app

# Copiando todos os arquivos da pasta main para pasta /app
COPY ./main .

# Build do binário do GO com flags -s -w
# para remover informações debugging
# e reduzir o tamanho do binario
RUN go build -ldflags="-s -w" main.go

# Reduzindo tamanho do binario final com UPX Packer
RUN upx --brute main

#ENTRYPOINT ["tail", "-f", "/dev/null"]
######################################################################################

# Stage 2 - Definindo imagem final
FROM scratch

# Copiando a pasta do arquivo compilado GO da imagem builder anterior
COPY --from=builder ./app/main .

ENTRYPOINT ["./main"]
######################################################################################