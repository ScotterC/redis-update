#Redis-update

This script updates Redis keys in a database by a provided pattern. Currently it just updates keys without a TTL to expire in 1 day.

##Usage
    redis-update.rb [host] [port] [dbnum] [(optional)pattern]

- **Host**: Generally this is 127.0.0.1 (Please note, running it remotely will cause the script to take significantly longer)
- **Port**: The port to connect to (e.g. 6379)
- **DBNum**: The Redis to connect to (e.g. 0)
- **pattern**: Defaults to "*"

##Other Redis Audit Tools
- [Redis Sampler](https://github.com/antirez/redis-sampler) - Samples keys for statistics around how often you each Redis value type, and how big the value is. By Antirez.
- [Redis Audit](https://github.com/snmaynard/redis-audit) - Audits keys.  Thanks to @snmaynard because redis-audit heavily influenced this script.