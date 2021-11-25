# Poor man's healthcheck
Uses cron & curl & telegram to ping url and notify if url is unhealthy

## Prerequisites
- `linux`
- `cron`
- `curl`
- `tail`
- create bot and add it to your group
- find group id with `make print_chat_ids` (`jq` needed)


## How to use
- `cp .env.example .env`
- `fill .env`
- `make check`, or
- `crontab -e` -> `* * * * * make -C /home/user/projects/poor_mans_healthchecker check`
