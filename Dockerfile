#builder image
FROM golang:1.18.0-alpine as builder
RUN mkdir /app
ADD . /app
WORKDIR /app
RUN go build -o main main.go

#run stage
FROM alpine:latest
WORKDIR /app
COPY --from=builder /app/main .
COPY app.env .
COPY start.sh .
COPY wait-for.sh .
COPY db/migration .db/migration
COPY frontend ./frontend

EXPOSE 8080
CMD [ "/app/main" ]
ENTRYPOINT [ "/app/start.sh" ]