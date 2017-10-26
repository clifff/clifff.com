For local development `build.sh` will update the Docker image, `run.sh` will start up a Jekyll server.

For "production", the Docker container is built, pushed to Heroku
(`heroku container:push builder --app APP_NAME`), and executed
hourly via free cron scheduler.
