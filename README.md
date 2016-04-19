## exchage-service
JSON API service for exchanging some amount of money into coins.

Nominals and starting amount of coins is specified in the [config](config.yml).
## API:
GET     `/`

Returns current payload of exchanger.
___

GET     `/exchage?amount=<param>`

Attempts to exchage `<param>` of money (in coins).
___

POST     `/add`
BODY     `{"1":1, "2":5}`

Adds money to the exchanger
___
