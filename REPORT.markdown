(Trans/Re)late

Project Partners: Jake Mittleman, Kevin Gendron, Marielle Riveros, Jon Anton

URL: transrelate.kevingendron.com

Github:[  
https://github.com/JakeMittlemanWebDev2019/project2.git](https://githu
b.com/JakeMittlemanWebDev2019/project2.git)

Is your app deployed and working?

Yes.

For each team member, what work did that person do on the project?

Jake and Jon worked on the translation API and functionality.
Marielle worked on user accounts and getting the photo feature set up 
for users. Kevin worked on the UX of the many different parts of the
website.

(Trans/Re)late

What does your project 2 app do?

(Trans/Re)late is a multi-lingual chatting app that auto-translates
messages so it appears as if all participants are speaking the same
language. It allows users to create an account, select in what
language they would like to send out/receive their messages, and
create chat rooms that can be joined by their peers. A user has the
ability to edit their account and change their default language at
any point while they are on the site. The selected language is also
persistent.

How do users interact with your application? What can they accomplish
by doing so?

Within the main feature of our app, users interact with our interface
by typing and sharing messages at the bottom of the screen. The UI is
as simple as typing a message and hitting "enter". Users can also
post images to each other by selecting "Choose File" underneath the
message bar and opening an image from their local drive. This enables
users to fluently communicate with other users that speak other
languages.

For each project requirement above, how does your app meet that
requirement?

-   In general, this application should be significantly more
ambitious and have more features than any previous assignment.

Our app builds on many of the assignments we completed this semester:
it uses react to post live updates, it uses Argon2 for password
authentication, it stores our postgres database on the server, it
contains relationships that are more complex than any assignment we
previously completed, and it successfully implements a complicated
Google API that allows a group of users speaking any number of
different languages to talk to each other. What added to the workload
of this assignment was designing an experience that was clear and
friendly to the user. Putting together what page layouts themselves
involved a lot of white boarding.

-   No more than two teams may build apps based on the same general
idea. Use the provided Piazza thread to claim your project ideas.

We claimed our idea on Piazza. It's original, and no one else in the
class is doing it.

-   The server side logic of your app must be built using Elixir /
Phoenix.

All of the data and logic that translates the messages users are
sending back and forth is built using Elixir / Phoenix (so yes, all
of the server side logic is built using Elixir/Phoenix).

-   Your application must have significant server-side / back-end
logic.

The logic behind receiving a message from a user with a specified
language, translating that message into the list of languages stored
in the room, and sending the translated message in the correct
language to all of the users in the room requires a significant
amount of functions as well as multiple files to execute. On top of
this, all of our schema and relationships are stored in the back-end
with many functions that allow us to retrieve data.  

-   All of your app must be deployed to the VPS(es) of one or more
members of your team.

The app is deployed on our team member, Kevin Gendron's VPS.

-   If you can self-host things on your VPS, you should. For example,
don't use an asset from a CDN when you can put it in your webpack
bundle.

Okay.

-   Your application should have user accounts, and should support
local password authentication (implemented securely).

Our application has user accounts and supports local password
authentication through the Argon2 library.

-   Users should be stored in a Postgres database, along with some
other non-trivial persistent state.

Users and chat rooms are both stored in a Postgres database.

-   Your application should use an external API that requires
authentication of your app, your app's user, or both.

We are using the Google Translate API that requires authentication of
the app.

-   API access for should be server <-> server. Your browser code
should only make requests to your server, not remote APIs.

Our application utilizes Google's Cloud API for language translation
and detection. When making a call to translate a message, we used an
Elixir-wrapper library to make using Google's API easier. Once a user
sends a message, that message is translated into every language
currently present in the room and a map is created with the structure
of "language" => "translated message". Then, when the message is to
be dispersed to every user, we retrieve the user's language from the
database and send them that translated message by indexing the map.

-   You must have at least two additional features [as was listed in
Inkfish].

We implemented real-time updates using chat messages within each chat
room. Every time a user sends a message or picture, it displays on
both the sender's and receiver's ends.

What's the complex part of your app? How did you design that
component and why? And what is the most significant challenge that
you faced? How did you solve it?

The complex part, and significant challenge, of our app is the
translation. Each room stores a list of languages for everyone in the
room. For example if there are 3 people in a room and they speak
"English", "French", and "French", the list of languages will be
"English" and "French". When a user enters a chatroom, their language
is retrieved from the database and added to that room's list of
languages. When a user sends a message, that message is translated
(in the server) once for each language in the room and stored in a
map with "language" => "message". Ex: Suppose "Hello, I am good" is
sent and there's a French user in the room, a map will be formed with
the structure "French" => "Bonjour, je suis bon". Then that map is
sent back to the channel and then that map is dispersed to each user
in a handle_out where the user's language is retrieved and used to
index the map and the correct message is sent back.

We designed it this way so that we could limit the amount of API
calls that were needed. Originally we had planned to translate every
message that was stored in addition to the new message into a certain
language (and based on each user's language). So we would translate
roughly 25 messages into Spanish maybe 3+ times which is 75 API
calls. This could quickly escalate, so instead we decided to keep
track of all the languages in the room and do one API call per
language (and only translate the most recent message).

What additional features did you implement?

We implemented real-time updates using chat messages within each chat
room. Every time a user sends a message or picture, it displays on
both the sender's and receiver's ends. Additionally, we used an
Elixir library called HTML_Entities to detect HTML unicode code
points in the messages and convert them into the correct characters.

What interesting stuff does your app include beyond the project
requirements?

Our app requires that a user select a unique username. If the user
happens to create a username that already exists in our database, an
error will be thrown that gently directs the user to enter a
different username. We have also added a feature that lets users
select a photo to be associated with their account. This involved
creating a one-to-one relationship between user and photos. There 
is a default photo associated with any account when the account is 
first created. If the user would like to add their own photo, they 
can do so under their profile where they have the option to upload 
an image from their local drive. 

