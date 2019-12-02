# Presentation Notes

## What App We Built

The app we built is a multi-person chat-room that auto translates messages so that people who speak different languages can communicate. It also allows sending photo messages, user account creation, password hashing, and log-in as well as user authentication.

## Live Demo

rock it.

## How Does Our App Work?

### Flow of the Program

The user begins by either creating an account, if they don't have one, or logging in. After that, the user has the option to either create a chat-room or join an exisitng one. Each chat-room keeps track of the languages that are present in the room. Once a user joins or creates a chat-room it adds their language (from the user database) to the list of languages for that room.

### Sending Messages

When a user sends a message, the message is sent, in addition to the list of languages, from the client to the server to be translated once into every language present in the chat-room. We then create a map from language => translated message and pass that map back to the controller. The controller then broadcasts the correct message to the user by matching the user's language from the database to the message in the map.

### Sending Photos

With sending a photo, when the user uploads a photo, we read the photo data and send it to the channel to be broadcasted to every user. Because photos don't need to be translated, every user gets the same message.

## Libraries and Tools

1) Google Cloud API - Translate (Elixir Wrapper)
1.5) Goth (Google Authentication for the API)
2) HTML Entities (for decoding HTML Unicode Code Points)
3) Elixir, Phoenix, and React
4) Multi-Page Application
5) Postgresql database (Users, Photos, Rooms)

## Major Challenges

- One of the biggest challenges was figuring out how to translate messages and use the API. It took a lot of work trying to make HTTP requests to Google's API until we found an Elxiir wrapper. After that, because the documentation was garbage, it took a while to learn how to use, but after that it worked.

- Another challenge was working with the POSTGRES database so that it only stores one photo at a time per user. If the user uploads a new photo, it should replace the current photo but instead it was just adding more. How we solved it was writing functions that retrieved data from the database including user information and check if they already had a photo linked to them. If they did, we delete their photo and create a new photo linked to them.

