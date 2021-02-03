# MVP API Design

This document details the APIs that we want to build for the features
required of the MVP.

They are:

- [Get dashboard](#get-dashboard)
- [Create comment](#create-comment)
- [Create reply](#create-reply)

# Get dashboard

This API endpoint is called by the SPA when it first boots. The endpoint
response with all the data required to render the posts view to the user.

It contains information about the current user as well as information about
the recent posts the user can view, their comments, their replies, and all
their authors.

This information is all grouped together in one endpoint so that the SPA does
not need to make multiple requests to multiple endpoints for all the data
before it can render the page to the user. This is faster to load (good user
experience) and faster for us to make (we don't need to make lots of
endpoints and SPA request code).

The number of posts returned is limited to the latest 14 (or some other
number). Later we can add an endpoint for users to fetch older posts in a
paginated fashion if they want.

**Note:** This API endpoint could be adapted from the existing `GET /v1/posts`
*endpoint as they are very similar.


## Request

- Method: `GET`
- Path: `/v1/dashboard`
- Parameters: None
- Authentication: User must be logged in via cookie
- Authorization: Any user can call this endpoint

## Response

- Status: 200
- Body: 
  ```json
  {
    "current_user": {
      "name": "otterboi"
    },
    "posts": [
      {
        "id": 1234,
        "inserted_at": "2021-02-03T20:08:42+00:00",
        "content": "hello, world!",
        "author": {
          "id": 4758,
          "username": "bumblebee"
        },
        "comments": []
      },
      {
        "id": 4422,
        "content": "Hello, world!",
        "inserted_at": "2021-02-03T20:08:42+00:00",
        "author": {
          "id": 4758,
          "username": "bumblebee"
        },
        "comments": [
          {
            "id": 4422,
            "content": "Hello, world!",
            "inserted_at": "2021-02-03T20:08:42+00:00",
            "author": {
              "id": 4422,
              "username": "snowdrops"
            },
            "replies": [
              {
                "id": 4422,
                "content": "Hello, world!",
                "inserted_at": "2021-02-03T20:08:42+00:00",
                "author": {
                  "id": 4758,
                  "username": "bumblebee"
                }
              }
            ]
          }
        ]
      }
    ] 
  }
  ```

# Create comment

TODO

# Create reply

TODO
