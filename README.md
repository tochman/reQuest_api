# README

## ENDPOINTS

All endpoints are prefixed with `/api`

### /requests

#### GET /requests

The get request will return all the requests in the database.
Offerable is null if auth headers are not included, and false if the request already has an offer by the user. True otherwise.
The format is:

```
{
  requests: [
    {
      id: 1,
      title: "Title",
      description: "Lots of text",
      requester: "requester@mail.com",
      reward: 100
      offerable: true
    }
  ]
}
```

#### POST /requests

To create a new request you need to include authentication headers.
You also need to provide :title=String and :description=String, and nothing else.
The response will be a 200 with a message and the id of the created resource

```
{ message: 'Your reQuest was successfully created!', id: <resource_id>, karma_points: <users karma_points> }
```

If auth is missing, devise will throw the following with 401:

```
{"errors"=>["You need to sign in or sign up before continuing."]}
```

If a param, e.g. description is missing, you will get 422:

```
{ message: 'Description can't be blank' }
```

If a non-permitted param is sent, you will get 422:

```
{ message: 'found unpermitted parameter: :body' }
```

If reQuester dont have enough karma points:
{ message: You dont have enough karma points }

All devise endpoints are available at /auth.
Read more [here](https://devise-token-auth.gitbook.io/devise-token-auth/).

### /karma_points

#### GET /karma_points

The get request will return the amount of karma points the user has stored.
if 200:
{ karma_points: 100 }
No error path!

### /offers

#### POST /offers

Auth headers are required. Param :request_id as integer required. Param :message as string optional.
If ok, response is 200:

```
{ message: 'Your offer has been sent!' }
```

Some other errors can happen as well, unauthorized 401 if headers are missing:

```
{"errors"=>["You need to sign in or sign up before continuing."]}
```

Or 422 if you try a forbidden action or have bad params:

```
{ message: 'You cannot offer help on your own request!' }
{ message: 'Helper_id is already registered with this request' }
{ message: "Couldn't find Request with 'id'=blob" }
```

#### PUT /offers

Auth headers are required. Param :activity that can be declined or accepted as string.

```
{ offer: offer.id, message: 'offer is accepted' }
{ offer: offer.id, message: 'offer is declined' }
```

if other activity response status 500 with message:

```
{ error_message: 'The activty is not valid' }
```

#### GET /offers/:id

Auth headers are required. Offer :id in endpoint.

```
{ offer: offer.id, message: 'Your offer is pending' }
{ offer: offer.id, message: 'Your offer has been accepted' }
{ offer: offer.id, message: 'Your offer has been declined' }
```
