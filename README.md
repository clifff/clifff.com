For local development `build.sh` will update the Docker image, `run.sh` will start up a Jekyll server.

For "production", the Docker container is built, pushed to Heroku
(`heroku container:push builder --app clifff-dot-com-builder`), and executed
hourly via free cron scheduler.

To get a production console:  `heroku run /bin/bash --app clifff-dot-com-builder --type builder`
