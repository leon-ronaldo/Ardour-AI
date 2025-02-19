# API Documentation - User module

## Methods
* Login
* Register
* Current user (jwt authentication)


### Method - Login
#### requires
```json
{
    "email": "string",
    "password": "string",
}
```


#### responses
```json
{
    "accessToken": "string",
    "refreshToken": "string",
}
```


#### response codes
| status code | response field | response data | cause |
|-------------|----------------|---------------|-------|
| 401 | message | All fields are mandatory! | Missing required data |
| 404 | message | No user found try creating one! | No user found |
| 201 | json data | access key and refresh key | Success |
| 401 | message | incorrect credentials | Wrong password |


### Method - Register
#### requires
```json
{
    "userName": "string",
    "email": "string",
    "password": "string",
    "phone": "string"
}
```


#### responses
```json
{
    "accessToken": "string",
    "refreshToken": "string",
}
```


#### response codes
| status code | response field | response data | cause |
|-------------|----------------|---------------|-------|
| 401 | message | All fields are mandatory! | Missing required data |
| 400 | message | User already exist try logging in | Registering with an existing email |
| 400 | message | User already exist try logging in | Registering with an existing email |
| 201 | json data | access key and refresh key | Success |
| 501 | message | Some error occured while creating user, try again! | Internal server error |


### Method - CurrentUser
#### requires (authorized get request)
######
```bash
curl -X GET http://your-api-url/current-user \
-H "Authorization: Bearer <your-access-token>" \
-H "Content-Type: application/json"
```


#### responses
######
```json
{
    "message": "string",
    "user": "user object"
}
```
| status code | response field | response data | cause |
|-------------|----------------|---------------|-------|
| 404 | message | User not found | Missing user |
| 401 | error | not an authorized user | invalid bearer token |
| 200 | json data | message "user success" and user | Success |
